module EPP
  class ServerError < RuntimeError; end
  class Server
    DEFAULT_SERVICES = %w(urn:ietf:params:xml:ns:domain-1.0
      urn:ietf:params:xml:ns:contact-1.0 urn:ietf:params:xml:ns:host-1.0)
    DEFAULTS = { :port => 700, :compatibility => false, :lang => 'en', :version => '1.0',
      :extensions => [], :services => DEFAULT_SERVICES }
    HEADER_LEN = 4

    def initialize(tag, passwd, host, options = {})
      @tag, @passwd, @host = tag, passwd, host
      @options = DEFAULTS.merge(options)
    end

    def request(command, payload = nil, &block)
      req = if payload.nil? && block_given?
        Request.new(command, next_tid, &block)
      else
        Request.new(command, payload, next_tid)
      end

      send_recv_frame(req.to_s)
    end

    def with_login
      login!

      begin
        yield
      ensure
        logout!
      end
    end
    def connection
      @conn = TCPSocket.new(@host, @options[:port])
      @sock = OpenSSL::SSL::SSLSocket.new(@conn)
      @sock.sync_close

      begin
        @sock.connect
        recv_frame  # Perform initial recv

        yield
      ensure
        @sock.close
        @conn.close
        conn = sock = nil
      end
    end
    private
      def next_tid
        @tid ||= 0
        @tid += 1
        "%s-%06d" % [@tag, @tid]
      end
      def login_request
        Request.new('login', next_tid) do |login|
          login << XML::Node.new('clID', @tag)
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
      def logout_request
        Request.new('logout')
      end
      def login!
        response = send_recv_frame(login_request.to_s)

        return true if response.code == 1000
        raise ResponseError.new(response.code, response.message, response.xml)
      end
      def logout!
        response = send_recv_frame(logout_request.to_s)

        return true if response.code == 1500
        raise ResponseError.new(response.code, response.message, response.xml)
      end
      def send_recv_frame(xml)
        send_frame(xml)
        Response.new(recv_frame)
      end
      def send_frame(xml)
        @sock.write([xml.size + 4].pack("N") + xml)
      end
      def recv_frame
        header = @sock.read(HEADER_LEN)

        if header.nil? && @sock.eof?
          raise ServerError, "Connection terminated by remote host"
        elsif header.nil?
          raise ServerError, "Failed to read header from remote host"
        else
          len = header.unpack('N')[0]
          
          raise ServerError, "Bad frame header from server, should be greater than #{HEADER_LEN}" unless len > HEADER_LEN
          response = @sock.read(length - HEADER_LEN)
        end
      end
  end
end
