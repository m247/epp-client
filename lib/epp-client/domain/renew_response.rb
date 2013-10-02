require File.expand_path('../response', __FILE__)

module EPP
  module Domain
    class RenewResponse < Response
      def name
        @name ||= value_for_xpath('//domain:name')
      end
      def expiration_date
        @date ||= Time.parse(value_for_xpath('//domain:exDate'))
      end
    end
  end
end
