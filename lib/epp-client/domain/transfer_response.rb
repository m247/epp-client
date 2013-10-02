require File.expand_path('../response', __FILE__)

module EPP
  module Domain
    class TransferResponse < Response
      def name
        @name ||= value_for_xpath('//domain:name')
      end
      def status
        @trStatus ||= value_for_xpath('//domain:trStatus')
      end
      def requested_id
        @reID ||= value_for_xpath('//domain:reID')
      end
      def requested_date
        @reDate ||= value_for_xpath('//domain:reDate') && Time.parse(value_for_xpath('//domain:reDate'))
      end
      def expiration_date
        @exDate ||= value_for_xpath('//domain:exDate') && Time.parse(value_for_xpath('//domain:exDate'))
      end
      def action_id
        @acID ||= value_for_xpath('//domain:acID')
      end
      def action_date
        @acDate ||= value_for_xpath('//domain:acDate') && Time.parse(value_for_xpath('//domain:acDate'))
      end
    end
  end
end
