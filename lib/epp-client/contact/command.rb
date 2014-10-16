module EPP
  module Contact
    class Command
      include XMLHelpers
      attr_reader :namespaces

      DISCLOSE_ORDER = ['name', 'org', 'addr', 'voice', 'fax', 'email']
      MAX_STREETS = 3

      class TooManyStreetLines < RuntimeError
        attr_reader :streets
        def initialize(streets)
          super("too many streets, #{streets[MAX_STREETS..-1]} would be excluded")
          @streets = streets
        end
      end

      def set_namespaces(namespaces)
        @namespaces = namespaces
      end

      def name
        raise NotImplementedError, "#name must be implemented in subclasses"
      end

      def to_xml
        @namespaces ||= {}
        node = contact_node(name)

        xattr = XML::Attr.new(node, "schemaLocation", SCHEMA_LOCATION)
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
          @namespaces['contact'] = xml_namespace(node, 'contact', NAMESPACE)
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

          if addr[:street]
            streets = addr[:street].split("\n")
            if streets.count > MAX_STREETS
              raise TooManyStreetLines.new(streets)
            end
            
            streets.each do |street|
              node << contact_node('street', street)
            end
          end

          node << contact_node('city', addr[:city])
          node << contact_node('sp', addr[:sp]) if addr[:sp]
          node << contact_node('pc', addr[:pc]) if addr[:pc]
          node << contact_node('cc', addr[:cc])

          node
        end
        def disclose_to_xml(disclose)
          flag = disclose.keys.first
          node = contact_node('disclose')
          node['flag'] = flag

          DISCLOSE_ORDER.each do |name|
            next unless disclose[flag].include?(name)
            node << n = contact_node(name)
            n['type'] = 'loc' if ['name', 'org', 'addr'].include?(name)
          end

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
