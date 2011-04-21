module EPP
  # Front facing EPP Client.
  #
  # Establishes a connection to an EPP server and allows for sending commands
  # to that EPP server.
  class Client
    # Create new instance of EPP::Client.
    #
    # @param [String] tag EPP Tag
    # @param [String] passwd EPP Tag password
    # @param [String] host EPP Host address
    # @param [Hash] options Options
    # @option options [Boolean] :compatibility If compatibility mode should be used?
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
    # @return [Request] last response received from the EPP server
    def _last_response
      @conn.last_response
    end

    # Send hello command
    def hello
      @conn.connection do
        @conn.hello
      end
    end

    # Calls an EPP command after connecting to the EPP Server and logging in.
    #
    # @overload method_missing(command, payload)
    #   @param [String, #to_s] command EPP Command to call
    #   @param [XML::Node, XML::Document, String] payload EPP XML Payload
    # @overload method_missing(command)
    #   @param [String, #to_s] command EPP Command to call
    #   @yield [xml] block to construct payload
    #   @yieldparam [XML::Node] xml XML Node of the command
    #     for the payload to be added into
    # @return [Response] EPP Response object
    def method_missing(command, payload = nil, &block)
      @conn.connection do
        @conn.with_login do
          @conn.request(command, payload, &block)
        end
      end
    end
  end
end
