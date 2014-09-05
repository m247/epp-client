require File.expand_path('../response', __FILE__)

module EPP
  module Domain
    class InfoResponse < Response
      def name
        @name ||= value_for_xpath('//domain:name')
      end
      def roid
        @roid ||= value_for_xpath('//domain:roid')
      end
      def status
        @status ||= value_for_xpath('//domain:status/@s')
      end
      def registrant
        @registrant ||= value_for_xpath('//domain:registrant')
      end
      def contacts
        @contacts ||= nodes_for_xpath('//domain:contact').each_with_object({}) do |node, hash|
          hash[node['type'].to_s] = node.content.strip
        end
      end
      def nameservers
        @nameservers ||= nodes_for_xpath('//domain:ns').map do |ns_node|
          ns = ns_node.find('domain:hostAttr', namespaces).map do |hostAttr|
            name_node = hostAttr.find('domain:hostName').first
            ipv4_node = hostAttr.find('domain:hostAddr[@ip="v4"]').first
            ipv6_node = hostAttr.find('domain:hostAddr[@ip="v6"]').first

            {}.tap do |result|
              result['name']= name_node.content.strip if name_node
              result['ipv4']= ipv4_node.content.strip if ipv4_node
              result['ipv6']= ipv6_node.content.strip if ipv6_node
            end
          end

          ns + ns_node.find('domain:hostObj').map { |n| { 'name' => n.content.strip } }
        end.flatten
      end
      def hosts
        @hosts ||= values_for_xpath('//domain:host')
      end
      def client_id
        @clid ||= value_for_xpath('//domain:clID')
      end
      def creator_id
        @crid ||= value_for_xpath('//domain:crID')
      end
      def created_date
        @crdate ||= value_for_xpath('//domain:crDate') && Time.parse(value_for_xpath('//domain:crDate'))
      end
      def updator_id
        @upid ||= value_for_xpath('//domain:upID')
      end
      def updated_date
        @update ||= value_for_xpath('//domain:upDate') && Time.parse(value_for_xpath('//domain:upDate'))
      end
      def expiration_date
        @exdate ||= value_for_xpath('//domain:exDate') && Time.parse(value_for_xpath('//domain:exDate'))
      end
      def transfer_date
        @trdate ||= value_for_xpath('//domain:trDate') && Time.parse(value_for_xpath('//domain:trDate'))
      end
      def auth_info
        @auth_info ||= begin
          { 'pw' => value_for_xpath('//domain:authInfo/domain:pw') }
        end
      end
    end
  end
end
