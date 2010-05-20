module EPP
  class Request
    # initialize(command, payload, transaction_id)
    # initialize(command, transaction_id) {|xml| payload }
    def initialize(command, *args, &block)
      @command = XML::Node.new(command)

      cmd = XML::Node.new('command')
      cmd << @command
      xml.root << cmd

      if block_given?
        tid, _ = args
        case block.arity
        when 1
          block.call(@command)
        else
          @command << block.call
        end
      else
        payload, tid = args
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
      end

      unless command == 'logout'
        cmd << XML::Node.new('clTRID', tid || 'ABC-12345')
      end
    end

    def command
      @command.name
    end

    def to_xml
      xml
    end
    def to_s(opts = {})
      xml.to_s({:indent => false}.merge(opts))
    end
    def inspect
      xml.inspect
    end

    private
      def xml
        @xml ||= prepare_request
      end
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
