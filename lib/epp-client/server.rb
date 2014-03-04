module EPP
  # A server error
  class ServerError < Error; end

  # A connection error
  class ConnectionError < Error
    attr_reader :error, :addr, :peeraddr
    def initialize(message, addr, peeraddr, error)
      super(message)
      @error = error
      @addr = addr
      @peeraddr = peeraddr
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
      :extensions => [], :services => EPP::Client::DEFAULT_SERVICES, :address_family => nil }

    # Receive frame header length
    # @private
    HEADER_LEN = 4

    # @param [String] tag EPP Tag
    # @param [String] passwd EPP Tag password
    # @param [String] host EPP Server address
    # @param [Hash] options configuration options
    # @option options [Integer] :port EPP Port number, default 700
    # @option options [OpenSSL::SSL::SSLContext] :ssl_context For client certificate auth
    # @option options [Boolean] :compatibility Compatibility mode, default false
    # @option options [String] :lang EPP Language code, default 'en'
    # @option options [String] :version EPP protocol version, default '1.0'
    # @option options [Array<String>] :extensions EPP Extension URNs
    # @option options [Array<String>] :services EPP Service URNs
    # @option options [String] :address_family 'AF_INET' or 'AF_INET6' or either of the
    #                          appropriate socket constants. Will cause connections to be
    #                          limited to this address family. Default try all addresses.

    def initialize(tag, passwd, host, options = {})
      @tag, @passwd, @host = tag, passwd, host
      @options = DEFAULTS.merge(options)
    end

    # Sends a Hello Request to the server
    # @return [Boolean] True if greeting was returned
    def hello
      hello   = EPP::Requests::Hello.new
      request = EPP::Request.new(hello)
      send_frame(request)
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
    # def request(command, payload = nil, extension = nil, &block)
    #   @req = if payload.nil? && block_given?
    #     Request.new(command, req_tid, &block)
    #   else
    #     Request.new(command, payload, extension, req_tid)
    #   end
    #
    #   @resp = send_recv_frame(@req)
    # end

    # @note Primarily an internal method, exposed to enable testing
    # @param [] command
    # @param [] extension
    # @return [EPP::Request]
    # @see request
    def prepare_request(command, extension = nil)
      cmd = EPP::Requests::Command.new(req_tid, command, extension)
      EPP::Request.new(cmd)
    end

    def request(command, extension = nil)
      @req = command.is_a?(EPP::Request) ? command :
                prepare_request(command, extension)

      @resp = send_recv_frame(@req)
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
    # Return the options the receiver was initialized with
    #
    # @return [Hash] configuration options
    def options
      @options
    end
    # Return the greeting XML received during the last connection
    #
    # @return [String]
    def greeting
      @greeting
    end

    # Runs a block while logged into the receiver
    #
    # @yield logged in EPP server session
    # @example typical usage
    #   connection do
    #     with_login do
    #       # .. do stuff with logged in session ..
    #     end
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
      @connection_errors = []
      addrinfo.each do |_,port,_,addr,_,_,_|
        retried = false
        begin
          @conn = TCPSocket.new(addr, port)
        rescue Errno::EINVAL => e
          if retried
            message = e.message.split(" - ")[1]
            raise Errno::EINVAL, "#{message}: TCPSocket.new(#{addr.inspect}, #{port.inspect})"
          end

          retried = true
          retry
        end

        args = [@conn]
        args << options[:ssl_context] if options[:ssl_context]
        @sock = OpenSSL::SSL::SSLSocket.new(*args)
        @sock.sync_close = true

        begin
          @sock.connect
          @greeting = recv_frame  # Perform initial recv

          return yield
        rescue Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::EHOSTUNREACH => e
          @connection_errors << e
          next # try the next address in the list
        rescue OpenSSL::SSL::SSLError => e
          # Connection error, most likely the IP isn't in the allow list
          if e.message =~ /returned=5 errno=0/
            @connection_errors << ConnectionError.new("SSL Connection error, IP may not be permitted to connect to #{@host}",
               @conn.addr, @conn.peeraddr, e)
            next
          else
            raise e
          end
        ensure
          @sock.close # closes @conn
          @conn = @sock = nil
        end
      end

      # Should only get here if we didn't return from the block above

      addrinfo(true) # Update our addrinfo in case the DNS has changed
      raise @connection_errors.last unless @connection_errors.empty?
      raise Errno::EHOSTUNREACH, "Failed to connect to host #{@host}"
    end
    private
      def addrinfo(refresh = false)
        @addrinfo = nil if refresh
        @addrinfo ||= resolve_addrinfo
      end
      def resolve_addrinfo
        family = case @options[:address_family]
        when 'AF_INET',  Socket::AF_INET  then Socket::AF_INET
        when 'AF_INET6', Socket::AF_INET6 then Socket::AF_INET6
        else nil end

        Socket.getaddrinfo(@host, @options[:port], family, Socket::SOCK_STREAM)
      end

      # @return [String] next transaction id
      def req_tid
        @req_tid ||= 0
        @req_tid += 1
        date = Time.now.strftime("%Y%m%d")
        "%s-%s%06d" % [@tag, date, @req_tid]
      end

      # @return [String] next auth transaction id
      def auth_tid
        @auth_tid ||= 0
        @auth_tid += 1
        date = Time.now.strftime("%Y%m%d")
        "%s-AUTH-%s%06d" % [@tag, date, @auth_tid]
      end

      # Perform login
      #
      # @return [true] login successful
      # @raise [ResponseError] login failed
      # @see login_request
      def login!
        @error   = nil
        login    = EPP::Commands::Login.new(@tag, @passwd, @options)
        command  = EPP::Requests::Command.new(auth_tid, login)
        request  = EPP::Request.new(command)
        response = send_recv_frame(request)

        return true if response.code == 1000
        raise @error = ResponseError.new(response.code, response.message, response.to_xml)
      end

      # Perform logout
      #
      # @return [true] logout successful
      # @raise [ResponseError] logout failed
      # @see logout_request
      def logout!
        logout   = EPP::Commands::Logout.new
        command  = EPP::Requests::Command.new(auth_tid, logout)
        request  = EPP::Request.new(command)
        response = send_recv_frame(request)

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
      # @param [String,Request] xml Payload to send
      # @return [Integer] number of bytes written
      def send_frame(xml)
        xml = xml.to_s if xml.kind_of?(Request)
        @sock.write([xml.size + HEADER_LEN].pack("N") + xml)
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
          @sock.read(len - HEADER_LEN)
        end
      end
  end
end
