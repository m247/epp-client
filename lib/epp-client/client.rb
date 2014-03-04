module EPP
  # Front facing EPP Client.
  #
  # Establishes a connection to an EPP server and allows for sending commands
  # to that EPP server.
  class Client
    # Default Service URNs
    #
    # Provided to make it easier for clients to add additional services to
    # the default list.
    #
    # @example
    #   services = DEFAULT_SERVICES + %w(urn:ietf:params:xml:ns:secDNS-1.1)
    #   EPP::Client.new('username','password','epp.example.com', :services => services)
    DEFAULT_SERVICES = [ Domain::NAMESPACE, Contact::NAMESPACE, Host::NAMESPACE ]

    # Create new instance of EPP::Client.
    #
    # @param [String] tag EPP Tag
    # @param [String] passwd EPP Tag password
    # @param [String] host EPP Host address
    # @param [Hash] options Options
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
      @tag, @passwd, @host, @options = tag, passwd, host, options
      @conn = if options.delete(:compatibility) == true
        OldServer.new(tag, passwd, host, options)
      else
        Server.new(tag, passwd, host, options)
      end
    end

    attr_reader :tag, :passwd, :host, :options

    def compatibility?
      @conn.is_a?(OldServer)
    end

    # Returns the last request sent to the EPP server
    #
    # @return [Request] last request sent to the EPP server
    def last_request
      @conn.last_request
    end

    # Returns the last request sent to the EPP server
    #
    # @deprecated
    # @return [Request] last request sent to the EPP server
    def _last_request
      warn "The #{self.class}#_last_request method is deprecated, please call #last_request"
      last_request
    end

    # Returns the last response received from the EPP server
    #
    # @return [Response] last response received from the EPP server
    def last_response
      @conn.last_response
    end

    # Returns the last response received from the EPP server
    #
    # @deprecated
    # @return [Response] last response received from the EPP server
    def _last_response
      warn "The #{self.class}#_last_response method is deprecated, please call #last_response"
      last_response
    end

    # Returns the last error received from a login or logout request
    #
    # @return [ResponseError] last error received from login/logout request
    def last_error
      @conn.last_error
    end

    # Returns the last error received from a login or logout request
    #
    # @deprecated
    # @return [ResponseError] last error received from login/logout request
    def _last_error
      warn "The #{self.class}#_last_error method is deprecated, please call #last_error"
      last_error
    end

    def greeting
      @conn.greeting
    end

    # Send hello command
    def hello
      @conn.connection do
        @conn.hello
      end
    end

    def check(payload, extension = nil)
      check = EPP::Commands::Check.new(payload)
      command(check, extension)
    end

    def create(payload, extension = nil)
      create = EPP::Commands::Create.new(payload)
      command(create, extension)
    end

    def delete(payload, extension = nil)
      delete = EPP::Commands::Delete.new(payload)
      command(delete, extension)
    end

    def info(payload, extension = nil)
      info = EPP::Commands::Info.new(payload)
      command(info, extension)
    end

    def renew(payload, extension = nil)
      renew = EPP::Commands::Renew.new(payload)
      command(renew, extension)
    end

    def transfer(op, payload, extension = nil)
      transfer = EPP::Commands::Transfer.new(op, payload)
      command(transfer, extension)
    end

    def update(payload, extension = nil)
      update = EPP::Commands::Update.new(payload)
      command(update, extension)
    end

    def poll
      poll = EPP::Commands::Poll.new
      command(poll)
    end
    def ack(msgID)
      ack = EPP::Commands::Poll.new(msgID)
      command(ack)
    end

    protected
      def command(cmd, extension = nil)
        @conn.connection do
          @conn.with_login do
            @conn.request(cmd, extension)
          end
        end
      end
  end
end
