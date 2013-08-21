require File.expand_path('../response', __FILE__)

module EPP
  module Domain
    class CreateResponse < Response
      def name
        @name ||= @response.data.find('//domain:name', namespaces).first.content.strip
      end
      def creation_date
        @crdate ||= Time.parse(@response.data.find('//domain:crDate', namespaces).first.content.strip)
      end
      def expiration_date
        @exdate ||= Time.parse(@response.data.find('//domain:exDate', namespaces).first.content.strip)
      end
    end
  end
end
