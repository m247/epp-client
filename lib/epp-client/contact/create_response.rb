require File.expand_path('../response', __FILE__)

module EPP
  module Contact
    class CreateResponse < Response
      def id
        @id ||= @response.data.find('//contact:id', namespaces).first.content.strip
      end
      def creation_date
        @crdate ||= Time.parse(@response.data.find('//contact:crDate', namespaces).first.content.strip)
      end
    end
  end
end
