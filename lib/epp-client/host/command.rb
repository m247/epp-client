module EPP
  module Host
    class Command
      include XMLHelpers

      def set_namespaces(namespaces)
        @namespaces = namespaces
      end

      def name
        raise NotImplementedError, "#name must be implemented in subclasses"
      end

      def to_xml
        @namespaces ||= {}
        node = host_node(name)

        xattr = XML::Attr.new(node, "schemaLocation", "urn:ietf:params:xml:ns:host-1.0 host-1.0.xsd")
        xattr.namespaces.namespace = @namespaces['xsi'] || XML::Namespace.new(node, 'xsi', 'http://www.w3.org/2001/XMLSchema-instance')
        
        node
      end

      protected
        def host_node(name, value = nil)
          node = xml_node(name, value)
          node.namespaces.namespace = host_namespace(node)
          node
        end
        def host_namespace(node)
          return @namespaces['host'] if @namespaces.has_key?('host')
          @namespaces['host'] = xml_namespace(node, 'host', 'urn:ietf:params:xml:ns:host-1.0')
        end

        def addrs_to_xml(node, addrs)
          addrs.each do |key, values|
            ip = key.to_s.sub('ip', '')
            Array(values).each do |value|
              node << addr = host_node('addr', value)
              addr['ip'] = ip
            end
          end
        end
    end
  end
end
