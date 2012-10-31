module EPP
  # A server error
  class ServerError < Error; end

  # A connection error
  class ConnectionError < Error
    attr_reader :inner_error
    def initialize(message, inner_error)
      super(message)
      @inner_error = inner_error
    end
  end

  # Handles sending and receiving data to EPP servers.
  # Supports new style EPP servers which include length of payloads in transmission.
  class Server
    # @!attribute DEFAULT_SERVICES
    # Provided for legacy clients who might be using it.
    # The constant has been moved into the EPP::Client class which
    # is the primary client facing API.
    #
    # @deprecated please use EPP::Client::DEFAULT_SERVICES
    # @see EPP::Client::DEFAULT_SERVICES

    # Handles emitting warnings for deprecated constants.
    #
    # @private
    # @param [Symbol] const_name Name of the missing constant
    # @see Module.const_missing
    def self.const_missing(const_name)
      case const_name
      when :DEFAULT_SERVICES
        warn "EPP::Server::DEFAULT_SERVICES has been deprecated, please use EPP::Client::DEFAULT_SERVICES"
        EPP::Client::DEFAULT_SERVICES
      else
        super
      end
    end

    # Default connection options
    DEFAULTS = { :port => 700, :compatibility => false, :lang => 'en', :version => '1.0',
      :extensions => [], :services => EPP::Client::DEFAULT_SERVICES }

    # Receive frame header length
    # @private
    HEADER_LEN = 4

    # @param [String] tag EPP Tag
    # @param [String] passwd EPP Tag password
    # @param [String] host EPP Server address
    # @param [Hash] options configuration options
    # @option options [Integer] :port EPP Port number, default 700
    # @option options [Boolean] :compatibility Compatibility mode, default false
    # @option options [String] :lang EPP Language code, default 'en'
    # @option options [String] :version EPP protocol version, default '1.0'
    # @option options [Array<String>] :extensions EPP Extension URNs
    # @option options [Array<String>] :services EPP Service URNs
    def initialize(tag, passwd, host, options = {})
      @tag, @passwd, @host = tag, passwd, host
      @options = DEFAULTS.merge(options)
    end

    # Sends a Hello Request to the server
    # @return [Boolean] True if greeting was returned
    def hello
      send_frame(HelloRequest.new.to_s)
      return true if recv_frame =~ /<greeting>/
      false
    end

    # Send request to server
    #
    # @overload request(command, payload)
    #   @param [String, #to_s] command EPP Command to call
    #   @param [XML::Node, XML::Document, String] payload EPP XML Payload
    # @overload request(command)
    #   @param [String, #to_s] command EPP Command to call
    #   @yield [xml] block to construct payload
    #   @yieldparam [XML::Node] xml XML Node of the command
    #     for the payload to be added into
    # @return [Response] EPP Response object
    def request(command, payload = nil, extension = nil, &block)
      @req = if payload.nil? && block_given?
        Request.new(command, next_tid, &block)
      else
        Request.new(command, payload, extension, next_tid)
      end

      @resp = send_recv_frame(@req.to_s)
    end

    # Return the Request object created by the last call to #request
    #
    # @return [Request] Last created EPP Request object
    def last_request
      @req
    end
    # Return the Response object created by the last call to #request
    #
    # @return [Response] Last created EPP Response object
    def last_response
      @resp
    end
    # Return the error from the last login or logout request
    #
    # @return [ResponseError] last error from login or logout
    def last_error
      @error
    end

    # Runs a block while logged into the receiver
    #
    # @yield logged in EPP server session
    # @example typical usage
    #   with_login do
    #     # .. do stuff with logged in session ..
    #   end
    def with_login
      login!

      begin
        yield
      ensure
        logout!
      end
    end

    # EPP Server Connection
    #
    # @yield connected session
    # @example typical usage
    #   connection do
    #     # .. do stuff with logged in session ..
    #   end
    # @example usage with with_login
    #   connection do
    #     with_login do
    #       # .. do stuff with logged in session ..
    #     end
    #   end
    def connection
      @conn = TCPSocket.new(@host, @options[:port])
      @sock = OpenSSL::SSL::SSLSocket.new(@conn)
      @sock.sync_close

      begin
        @sock.connect
        recv_frame  # Perform initial recv

        yield
      rescue OpenSSL::SSL::SSLError => e
        # Connection error, most likely the IP isn't in the allow list
        if e.message =~ /returned=5 errno=0/
          raise ConnectionError.new("SSL Connection error, your IP address might not be permitted to connect to #{@host}", e)
        else
          raise e
        end
      ensure
        @sock.close
        @conn.close
        conn = sock = nil
      end
    end
    private
      # @return [String] next transaction id
      def next_tid
        @tid ||= 0
        @tid += 1
        "%s-%06d" % [@tag, @tid]
      end

      # @return [Request] Login Request Payload
      def login_request
        @req = Request.new('login', next_tid) do |login|
          tag = @tag.length > 2 ? @tag : "##{@tag}"
          login << XML::Node.new('clID', tag)
          login << XML::Node.new('pw', @passwd)

          options = XML::Node.new('options')
          options << XML::Node.new('version', @options[:version])
          options << XML::Node.new('lang', @options[:lang])
          login << options

          svcs = XML::Node.new('svcs')
          @options[:services].each { |uri| svcs << XML::Node.new('objURI', uri) }
          login << svcs

          unless @options[:extensions].empty?
            ext = XML::Node.new('svcExtension')
            @options[:extensions].each do |uri|
              ext << XML::Node.new('extURI', uri)
            end
            svcs << ext
          end
        end
      end

      # @return [Request] Logout Request Payload
      def logout_request
        Request.new('logout')
      end

      # Perform login
      #
      # @return [true] login successful
      # @raise [ResponseError] login failed
      # @see login_request
      def login!
        @error = nil
        response = send_recv_frame(login_request.to_s)

        return true if response.code == 1000
        raise @error = ResponseError.new(response.code, response.message, response.to_xml)
      end

      # Perform logout
      #
      # @return [true] logout successful
      # @raise [ResponseError] logout failed
      # @see logout_request
      def logout!
        response = send_recv_frame(logout_request.to_s)

        return true if response.code == 1500
        raise @error = ResponseError.new(response.code, response.message, response.to_xml)
      end

      # Send a frame and receive its response
      #
      # @param [String] xml XML Payload to send
      # @return [Response] EPP Response
      # @see send_frame
      # @see recv_frame
      def send_recv_frame(xml)
        send_frame(xml)
        Response.new(recv_frame)
      end

      # Send XML frame
      # @return [Integer] number of bytes written
      def send_frame(xml)
        @sock.write([xml.size + 4].pack("N") + xml)
      end

      # Receive XML frame
      # @return [String] XML response
      def recv_frame
        header = @sock.read(HEADER_LEN)

        if header.nil? && @sock.eof?
          raise ServerError, "Connection terminated by remote host"
        elsif header.nil?
          raise ServerError, "Failed to read header from remote host"
        else
          len = header.unpack('N')[0]
          
          raise ServerError, "Bad frame header from server, should be greater than #{HEADER_LEN}" unless len > HEADER_LEN
          response = @sock.read(len - HEADER_LEN)
        end
      end
  end
end
