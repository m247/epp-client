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
    DEFAULT_SERVICES = %w(
      urn:ietf:params:xml:ns:domain-1.0
      urn:ietf:params:xml:ns:contact-1.0
      urn:ietf:params:xml:ns:host-1.0 )

    # Create new instance of EPP::Client.
    #
    # @param [String] tag EPP Tag
    # @param [String] passwd EPP Tag password
    # @param [String] host EPP Host address
    # @param [Hash] options Options
    # @option options [Integer] :port EPP Port number, default 700
    # @option options [Boolean] :compatibility Compatibility mode, default false
    # @option options [String] :lang EPP Language code, default 'en'
    # @option options [String] :version EPP protocol version, default '1.0'
    # @option options [Array<String>] :extensions EPP Extension URNs
    # @option options [Array<String>] :services EPP Service URNs
    def initialize(tag, passwd, host, options = {})
      @conn = if options.delete(:compatibility) == true
        OldServer.new(tag, passwd, host, options)
      else
        Server.new(tag, passwd, host, options)
      end
    end

    # Returns the last request sent to the EPP server
    #
    # @return [Request] last request sent to the EPP server
    def _last_request
      @conn.last_request
    end

    # Returns the last response received from the EPP server
    #
    # @return [Response] last response received from the EPP server
    def _last_response
      @conn.last_response
    end

    # Returns the last error received from a login or logout request
    #
    # @return [ResponseError] last error received from login/logout request
    def _last_error
      @conn.last_error
    end

    # Send hello command
    def hello
      @conn.connection do
        @conn.hello
      end
    end

    # Calls an EPP command after connecting to the EPP Server and logging in.
    #
    # @overload method_missing(command, payload, extension)
    #   @param [String, #to_s] command EPP Command to call
    #   @param [XML::Node, XML::Document, String] payload EPP XML Payload
    #   @param [XML::Node, XML::Document, String] extension EPP XML Extension
    # @overload method_missing(command) { |cmd, ext| payload }
    #   @param [String, #to_s] command EPP Command to call
    #   @yield [cmd, ext] block to construct payload
    #   @yieldparam [XML::Node] cmd XML Node of the command
    #     for the payload to be added into
    #   @yieldparam [XML::Node] ext XML Node of the extension block
    #     for the extension payload to be added into
    # @return [Response] EPP Response object
    def method_missing(command, payload = nil, extension = nil, &block)
      @conn.connection do
        @conn.with_login do
          @conn.request(command, payload, extension, &block)
        end
      end
    end
  end
end
