require File.expand_path('../response', __FILE__)

module EPP
  module Domain
    class CreateResponse < Response
      def name
        return nil unless success?
        @name ||= value_for_xpath('//domain:name')
      end
      def creation_date
        return nil unless success?
        @crdate ||= value_for_xpath('//domain:crDate') && Time.parse(value_for_xpath('//domain:crDate'))
      end
      def expiration_date
        return nil unless success?
        @exdate ||= value_for_xpath('//domain:exDate') && Time.parse(value_for_xpath('//domain:exDate'))
      end
    end
  end
end
