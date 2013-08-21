module EPP
  # An EPP XML Request
  class Request
    include XMLHelpers

    # Create and return a new EPP Request Payload
    #
    # @param [EPP::Request]
    def initialize(request)
      @request = request
    end

    def namespaces
      @namespaces
    end

    # Receiver in XML form
    # @return [XML::Document] XML of the receiver
    def to_xml
      doc      = XML::Document.new('1.0')
      doc.root = XML::Node.new('epp')
      root     = doc.root

      epp_ns   = XML::Namespace.new(root, nil, 'urn:ietf:params:xml:ns:epp-1.0')
      root.namespaces.namespace = epp_ns

      xsi_ns   = XML::Namespace.new(root, 'xsi', 'http://www.w3.org/2001/XMLSchema-instance')
      xsi_sL   = XML::Attr.new(root, 'schemaLocation', 'urn:ietf:params:xml:ns:epp-1.0 epp-1.0.xsd')
      xsi_sL.namespaces.namespace = xsi_ns

      @namespaces = {'epp' => epp_ns, 'xsi' => xsi_ns}

      @request.set_namespaces(@namespaces) if @request.respond_to?(:set_namespaces)
      root << @request.to_xml

      doc
    end

    # Convert the receiver to a string
    #
    # @param [Hash] opts Formatting options, passed to the XML::Document
    def to_s(opts = {})
      to_xml.to_s({:indent => false}.merge(opts))
    end

    # @see Object#inspect
    # def inspect
    #   "#<#{self.class}>"
    # end
  end
end
