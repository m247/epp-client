module EPP
  module Commands
    class Command
      include XMLHelpers

      def set_namespaces(namespaces)
        @namespaces = namespaces
      end

      # Receiver in XML form
      # @return [XML::Document] XML of the receiver
      def to_xml
        epp_node(name, @namespaces || {})
      end

      # Convert the receiver to a string
      #
      # @param [Hash] opts Formatting options, passed to the XML::Document
      def to_s(opts = {})
        to_xml.to_s({:indent => false}.merge(opts))
      end
    end
  end
end
