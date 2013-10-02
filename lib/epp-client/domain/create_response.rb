require File.expand_path('../response', __FILE__)

module EPP
  module Domain
    class CreateResponse < Response
      def name
        @name ||= value_for_xpath('//domain:name')
      end
      def creation_date
        @crdate ||= value_for_xpath('//domain:crDate') && Time.parse(value_for_xpath('//domain:crDate'))
      end
      def expiration_date
        @exdate ||= value_for_xpath('//domain:exDate') && Time.parse(value_for_xpath('//domain:exDate'))
      end
    end
  end
end
