module EPP
  # An EPP XML Request
  class Request
    # Create new instance of EPP::Request.
    #
    # @overload initialize(command, payload, extension, transaction_id)
    #   @param [String, #to_s] command EPP Command to call
    #   @param [XML::Node, XML::Document, String] payload XML Payload to transmit
    #   @param [String] transaction_id EPP Transaction ID
    # @overload initialize(command, transaction_id) {|cmd, ext| payload }
    #   @param [String, #to_s] command EPP Command to call
    #   @param [String] transaction_id EPP Transaction ID
    #   @yield [cmd,ext] block to construct payload
    #   @yieldparam [XML::Node] cmd XML Node of the command
    #     for the payload to be added into
    #   @yieldparam [XML::Node] ext XML Node of the extension
    def initialize(command, *args, &block)
      @command = XML::Node.new(command)

      cmd = XML::Node.new('command')
      cmd << @command
      xml.root << cmd

      ext = XML::Node.new('extension')

      if block_given?
        tid, _ = args
        case block.arity
        when 1
          block.call(@command)
        when 2
          block.call(@command, ext)
        else
          @command << block.call
        end
      else
        payload, extension, tid = args
        unless payload.nil?
          @command << case payload.class
            when XML::Node
              payload
            when XML::Document
              xml.import(payload.root)
            else
              doc = XML::Parser.string(payload.to_s).parse
              xml.import(doc.root)
          end
        end

        unless extension.nil?
          ext << case extension.class
            when XML::Node
              extension
            when XML::Document
              xml.import(extension.root)
            else
              doc = XML::Parser.string(extension.to_s).parse
              xml.import(doc.root)
          end
        end
      end

      cmd << ext if ext.children?

      unless command == 'logout'
        cmd << XML::Node.new('clTRID', tid || 'ABC-12345')
      end
    end

    # Name of the receivers command
    # @return [String] command name
    def command
      @command.name
    end

    # Receiver in XML form
    # @return [XML::Document] XML of the receiver
    def to_xml
      xml
    end

    # Convert the receiver to a string
    #
    # @param [Hash] opts Formatting options, passed to the XML::Document
    def to_s(opts = {})
      xml.to_s({:indent => false}.merge(opts))
    end

    # @see Object#inspect
    def inspect
      xml.inspect
    end

    private
      # Request XML Payload
      # @see prepare_request
      def xml
        @xml ||= prepare_request
      end

      # Prepares the base XML for the request
      #
      # @return [XML::Document]
      def prepare_request
        xml = XML::Document.new('1.0')
        xml.root = XML::Node.new('epp')
        xml.root.namespaces.namespace =
          XML::Namespace.new(xml.root, nil, 'urn:ietf:params:xml:ns:epp-1.0')
        XML::Namespace.new(xml.root, 'xsi', 'http://www.w3.org/2001/XMLSchema-instance')
        xml.root['xsi:schemaLocation'] = "urn:ietf:params:xml:ns:epp-1.0 epp-1.0.xsd"

        xml
      end
  end
end
