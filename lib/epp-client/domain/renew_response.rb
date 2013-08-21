require File.expand_path('../response', __FILE__)

module EPP
  module Domain
    class RenewResponse < Response
      def name
        @name ||= @response.data.find('//domain:name', namespaces).first.content.strip
      end
      def expiration_date
        @date ||= Time.parse(@response.data.find('//domain:exDate', namespaces).first.content.strip)
      end
    end
  end
end
