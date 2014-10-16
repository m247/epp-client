module EPP
  module Domain
    class Command
      include XMLHelpers
      attr_reader :namespaces

      def set_namespaces(namespaces)
        @namespaces = namespaces
      end

      def name
        raise NotImplementedError, "#name must be implemented in subclasses"
      end

      def to_xml
        @namespaces ||= {}
        node = domain_node(name)

        xattr = XML::Attr.new(node, "schemaLocation", SCHEMA_LOCATION)
        xattr.namespaces.namespace = @namespaces['xsi'] || XML::Namespace.new(node, 'xsi', 'http://www.w3.org/2001/XMLSchema-instance')
        
        node
      end

      protected
        def domain_node(name, value = nil)
          node = xml_node(name, value)
          node.namespaces.namespace = domain_namespace(node)
          node
        end
        def domain_namespace(node)
          return @namespaces['domain'] if @namespaces.has_key?('domain')
          @namespaces['domain'] = xml_namespace(node, 'domain', NAMESPACE)
        end
        
        def validate_period(period)
          unit = period[-1,1].downcase
          val  = period.to_i
          
          raise ArgumentError, "period suffix must either be 'm' or 'y'" unless %w(m y).include?(unit)
          raise ArgumentError, "period value must be in the range 1-99" if val < 1 || val > 99
          
          return val.to_s, unit
        end

        def auth_info_to_xml(auth_info)
          a = domain_node('authInfo')

          if auth_info.has_key?(:pw)
            a << pw = domain_node('pw', auth_info[:pw])
            pw['roid'] = auth_info[:roid] if auth_info.has_key?(:roid)
          elsif auth_info.has_key?(:ext)
            a << domain_node('ext', auth_info[:ext])
          end

          a
        end
        
        def nameservers_to_xml(nameservers)
          ns = domain_node('ns')

          nameservers.each do |nameserver|
            case nameserver
            when String
              ns << domain_node('hostObj', nameserver)
            when Hash
              ns << hostAttr = domain_node('hostAttr')
              hostAttr << domain_node('hostName', nameserver[:name])
              Array(nameserver[:ipv4]).each do |addr|
                hostAttr << a = domain_node('hostAddr', addr)
                a['ip'] = 'v4'
              end
              Array(nameserver[:ipv6]).each do |addr|
                hostAttr << a = domain_node('hostAddr', addr)
                a['ip'] = 'v6'
              end
            end
          end

          ns
        end
        def contacts_to_xml(node, contacts)
          return if contacts.nil?
          contacts.each do |type, roid|
            next unless %w(admin tech billing).include?(type.to_s)
            node << c = domain_node('contact', roid)
            c['type'] = type.to_s
          end
        end
    end
  end
end
