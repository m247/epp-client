module EPP
  module XMLHelpers
    # Creates and returns an instance of the EPP 1.0 namespace
    #
    # @param [XML::Node] node to create the namespace on
    # @param [String, nil] Name to give the namespace
    # @return [XML::Namespace] EPP 1.0 namespace
    def epp_namespace(node, name = nil, namespaces = {})
      return namespaces['epp'] if namespaces.has_key?('epp')
      xml_namespace(node, name, 'urn:ietf:params:xml:ns:epp-1.0')
    end
    
    # Creates and returns a new node in the EPP 1.0 namespace
    #
    # @param [String] name of the node to create
    # @param [String,XML::Node,nil] value of the node
    # @return [XML::Node]
    def epp_node(name, value = nil, namespaces = {})
      value, namespaces = nil, value if value.kind_of?(Hash)

      node = xml_node(name, value)
      node.namespaces.namespace = epp_namespace(node, nil, namespaces)
      node
    end

    # Creates and returns a new XML node
    #
    # @param [String] name of the node to create
    # @param [String,XML::Node,nil] value of the node
    # @return [XML::Node]
    def xml_node(name, value = nil)
      XML::Node.new(name, value)
    end

    # Creates and returns a new XML namespace
    #
    # @param [XML::Node] node XML node to add the namespace to
    # @param [String] name Name of the namespace to create
    # @param [String] uri URI of the namespace to create
    # @return [XML::Namespace]
    def xml_namespace(node, name, uri, namespaces = {})
      XML::Namespace.new(node, name, uri)
    end

    # Creates and returns a new XML document
    #
    # @param [XML::Document,String] obj Object to create the document with
    # @return [XML::Document]
    def xml_document(obj)
      case obj
      when XML::Document
        XML::Document.document(obj)
      else
        XML::Document.new('1.0')
      end
    end    
    
    def as_xml(obj)
      return obj.to_xml if obj.respond_to?(:to_xml)

      case obj
      when String
        XML::Document.string(obj).root
      when XML::Node
        obj
      when XML::Document
        obj.root
      end
    end
  end
end
