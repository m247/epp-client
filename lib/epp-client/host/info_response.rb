require File.expand_path('../response', __FILE__)

module EPP
  module Host
    class InfoResponse < Response
      def name
        @name ||= value_for_xpath('//host:name')
      end
      def roid
        @roid ||= value_for_xpath('//host:roid')        
      end
      def status
        @status ||= values_for_xpath('//host:status/@s')
      end
      def addresses
        @addresses ||= nodes_for_xpath('//host:addr').inject({}) do |hash, node|
          hash["ip#{node['ip']}"] ||= Array.new
          hash["ip#{node['ip']}"] << node.content.strip
          hash
        end
      end
      def client_id
        @clid ||= value_for_xpath('//host:clID')
      end
      def creator_id
        @crid ||= value_for_xpath('//host:crID')
      end
      def created_date
        @crdate ||= value_for_xpath('//host:crDate') && Time.parse(value_for_xpath('//host:crDate'))
      end
      def updator_id
        @upid ||= value_for_xpath('//host:upID')
      end
      def updated_date
        @update ||= value_for_xpath('//host:upDate') && Time.parse(value_for_xpath('//host:upDate'))
      end
      def transfer_date
        @trdate ||= value_for_xpath('//host:trDate') && Time.parse(value_for_xpath('//host:trDate'))
      end
    end
  end
end
