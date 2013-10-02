require File.expand_path('../response', __FILE__)

module EPP
  module Contact
    class CreateResponse < Response
      def id
        @id ||= value_for_xpath('//contact:id')
      end
      def creation_date
        @crdate ||= value_for_xpath('//contact:crDate') && Time.parse(value_for_xpath('//contact:crDate'))
      end
    end
  end
end
