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
        @contacts ||= nodes_for_xpath('//domain:contact').inject({}) do |hash, node|
          hash[node['type'].to_s] = node.content.strip
          hash
        end
      end
      def nameservers
        @nameservers ||= nodes_for_xpath('//domain:ns').map do |ns_node|
          ns = ns_node.find('domain:hostAttr', namespaces).map do |hostAttr|
            { 'name' => hostAttr.find('domain:name').first.content.strip,
              'ipv4' => hostAttr.find('domain:addr[@ip="v4"]').first.content.strip,
              'ipv6' => hostAttr.find('domain:addr[@ip="v6"]').first.content.strip }
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
