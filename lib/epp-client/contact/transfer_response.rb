require File.expand_path('../response', __FILE__)

module EPP
  module Contact
    class TransferResponse < Response
      def id
        @id ||= @response.data.find('//contact:id').first.content.strip
      end
      def status
        @trStatus ||= @response.data.find('//contact:trStatus').first.content.strip
      end
      def requested_id
        @reID ||= @response.data.find('//contact:reID').first.content.strip
      end
      def requested_date
        @reDate ||= Time.parse(@response.data.find('//contact:reDate').first.content.strip)
      end
      def action_id
        @acID ||= @response.data.find('//contact:acID').first.content.strip
      end
      def action_date
        @acDate ||= Time.parse(@response.data.find('//contact:acDate').first.content.strip)
      end
    end
  end
end
