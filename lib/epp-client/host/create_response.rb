require File.expand_path('../response', __FILE__)

module EPP
  module Host
    class CreateResponse < Response
      def name
        @name ||= value_for_xpath('//host:name')
      end
      def creation_date
        @crdate ||= Time.parse(value_for_xpath('//host:crDate'))
      end
    end
  end
end
