require File.expand_path('../response', __FILE__)

module EPP
  module Contact
    class TransferResponse < Response
      def id
        @id ||= value_for_xpath('//contact:id')
      end
      def status
        @trStatus ||= value_for_xpath('//contact:trStatus')
      end
      def requested_id
        @reID ||= value_for_xpath('//contact:reID')
      end
      def requested_date
        @reDate ||= value_for_xpath('//contact:reDate') && Time.parse(value_for_xpath('//contact:reDate'))
      end
      def action_id
        @acID ||= value_for_xpath('//contact:acID')
      end
      def action_date
        @acDate ||= value_for_xpath('//contact:acDate') && Time.parse(value_for_xpath('//contact:acDate'))
      end
    end
  end
end
