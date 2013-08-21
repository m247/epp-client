require File.expand_path('../response', __FILE__)

module EPP
  module Domain
    class InfoResponse < Response
      def name
        @name ||= @response.data.find('//domain:name', namespaces).first.content.strip
      end
      def roid
        @roid ||= @response.data.find('//domain:roid', namespaces).first.content.strip        
      end
      def status
        @status ||= @response.data.find('//domain:status/@s', namespaces).first.value
      end
      def registrant
        @registrant ||= @response.data.find('//domain:registrant', namespaces).first.content.strip
      end
      def contacts
        @contacts ||= @response.data.find('//domain:contact', namespaces).inject({}) do |hash, node|
          hash[node['type'].to_s] = node.content.strip
          hash
        end
      end
      def nameservers
        @nameservers ||= @response.data.find('//domain:ns', namespaces).map do |ns_node|
          ns = ns_node.find('domain:hostAttr', namespaces).map do |hostAttr|
            { 'name' => hostAttr.find('domain:name').first.content.strip,
              'ipv4' => hostAttr.find('domain:addr[@ip="v4"]').first.content.strip,
              'ipv6' => hostAttr.find('domain:addr[@ip="v6"]').first.content.strip }
          end
          
          ns + ns_node.find('domain:hostObj').map { |n| n.content.strip }
        end.flatten
      end
      def hosts
        @hosts ||= @response.data.find('//domain:host', namespaces).map { |n| n.content.strip }
      end
      def client_id
        @clid ||= @response.data.find('//domain:clID', namespaces).first.content.strip
      end
      def creator_id
        @crid ||= @response.data.find('//domain:crID', namespaces).first.content.strip
      end
      def created_date
        @crdate ||= Time.parse(@response.data.find('//domain:crDate', namespaces).first.content.strip)
      end
      def updator_id
        @upid ||= @response.data.find('//domain:upID', namespaces).first.content.strip
      end
      def updated_date
        @update ||= Time.parse(@response.data.find('//domain:upDate', namespaces).first.content.strip)
      end
      def expiration_date
        @exdate ||= Time.parse(@response.data.find('//domain:exDate', namespaces).first.content.strip)
      end
      def transfer_date
        @trdate ||= Time.parse(@response.data.find('//domain:trDate', namespaces).first.content.strip)
      end
      def auth_info
        @auth_info ||= begin
          { 'pw' => @response.data.find('//domain:authInfo/domain:pw').first.content.strip }
        end
      end
    end
  end
end
