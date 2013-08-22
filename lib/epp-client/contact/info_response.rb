require File.expand_path('../response', __FILE__)

module EPP
  module Contact
    class InfoResponse < Response
      def id
        @id ||= value_for_xpath('//contact:id')
      end
      def roid
        @roid ||= value_for_xpath('//contact:roid')
      end
      def status
        @status ||= values_for_xpath('//contact:status/@s')
      end
      def email
        @email ||= value_for_xpath('//contact:email')
      end
      def fax
        @fax ||= value_for_xpath('//contact:fax') do |node|
          [node.content.strip, node['x']].compact.join(".")
        end
      end
      def voice
        @voice ||= value_for_xpath('//contact:voice') do |node|
          [node.content.strip, node['x']].compact.join(".")
        end
      end
      def postal_info
        @postal_info ||= {
          :name => value_for_xpath('//contact:postalInfo/contact:name'),
          :org  => value_for_xpath('//contact:postalInfo/contact:org'),
          :addr => {
            :street => values_for_xpath('//contact:postalInfo/contact:addr/contact:street').join("\n"),
            :city   => value_for_xpath('//contact:postalInfo/contact:addr/contact:city'),
            :sp     => value_for_xpath('//contact:postalInfo/contact:addr/contact:sp'), 
            :pc     => value_for_xpath('//contact:postalInfo/contact:addr/contact:pc'),
            :cc     => value_for_xpath('//contact:postalInfo/contact:addr/contact:cc')
          }
        }
      end
      def client_id
        @clid ||= value_for_xpath('//contact:clID')
      end
      def creator_id
        @crid ||= value_for_xpath('//contact:crID')
      end
      def created_date
        @crdate ||= Time.parse(value_for_xpath('//contact:crDate'))
      end
      def updator_id
        @upid ||= value_for_xpath('//contact:upID')
      end
      def updated_date
        @update ||= Time.parse(value_for_xpath('//contact:upDate'))
      end
      def transfer_date
        @trdate ||= Time.parse(value_for_xpath('//contact:trDate'))
      end
      def auth_info
        @auth_info ||= begin
          { 'pw' => value_for_xpath('//contact:authInfo/contact:pw') }
        end
      end
      def disclose
        @disclose ||= begin
          nodes_for_xpath('//contact:disclose').inject({}) do |hash, node|
            hash[node['flag'].to_s] = node.children.reject{|n| n.empty?}.map { |child| child.name }
            hash
          end
        end
      end
    end
  end
end
