require File.expand_path('../response', __FILE__)

module EPP
  module Domain
    class TransferResponse < Response
      def status
        @trStatus ||= @response.data.find('//domain:trStatus').first.content.strip
      end
      def requested_id
        @reID ||= @response.data.find('//domain:reID').first.content.strip
      end
      def requested_date
        @reDate ||= Time.parse(@response.data.find('//domain:reDate').first.content.strip)
      end
      def expiration_date
        @exDate ||= Time.parse(@response.data.find('//domain:exDate').first.content.strip)
      end
      def action_id
        @acID ||= @response.data.find('//domain:acID').first.content.strip
      end
      def action_date
        @acDate ||= Time.parse(@response.data.find('//domain:acDate').first.content.strip)
      end
    end
  end
end
