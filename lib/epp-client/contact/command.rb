module EPP
  module Contact
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
        node = contact_node(name)

        xattr = XML::Attr.new(node, "schemaLocation", "urn:ietf:params:xml:ns:contact-1.0 contact-1.0.xsd")
        xattr.namespaces.namespace = @namespaces['xsi'] || XML::Namespace.new(node, 'xsi', 'http://www.w3.org/2001/XMLSchema-instance')

        node
      end

      protected
        def contact_node(name, value = nil)
          node = xml_node(name, value)
          node.namespaces.namespace = contact_namespace(node)
          node
        end
        def contact_namespace(node)
          return @namespaces['contact'] if @namespaces.has_key?('contact')
          @namespaces['contact'] = xml_namespace(node, 'contact', 'urn:ietf:params:xml:ns:contact-1.0')
        end

        def postal_info_to_xml(postal_info)
          node = contact_node('postalInfo')
          node['type'] = 'loc'

          node << contact_node('name', postal_info[:name])
          node << contact_node('org', postal_info[:org]) if postal_info[:org]
          node << addr_to_xml(postal_info[:addr])

          node
        end
        def addr_to_xml(addr)
          node = contact_node('addr')

          node << contact_node('street', addr[:street]) if addr[:street]
          node << contact_node('city', addr[:city])
          node << contact_node('sp', addr[:sp]) if addr[:sp]
          node << contact_node('pc', addr[:pc]) if addr[:pc]
          node << contact_node('cc', addr[:cc])

          node
        end
        def disclose_to_xml(disclose)
          node = contact_node('disclose')
          node['flag'] = '1' # '0'

          # Each field has a type field with 'loc' or 'int'
          node << contact_node('name',  disclose[:name])  if disclose[:name]
          node << contact_node('org',   disclose[:org])   if disclose[:org]
          node << contact_node('addr',  disclose[:addr])  if disclose[:addr]
          node << contact_node('voice', disclose[:voice]) if disclose[:voice]
          node << contact_node('fax',   disclose[:fax])   if disclose[:fax]
          node << contact_node('email', disclose[:email]) if disclose[:email]

          node
        end

        def auth_info_to_xml(auth_info)
          a = contact_node('authInfo')

          if auth_info.has_key?(:pw)
            a << pw = contact_node('pw', auth_info[:pw])
            pw['roid'] = auth_info[:roid] if auth_info.has_key?(:roid)
          elsif auth_info.has_key?(:ext)
            a << contact_node('ext', auth_info[:ext])
          end

          a
        end
    end
  end
end
