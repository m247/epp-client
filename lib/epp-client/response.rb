module Epp
  class Response
    def initialize(xml_string)
      @xml = XML::Parser.string(xml_string).parse
      @xml.root.namespaces.default_prefix = 'e'
    end

    def xml
      @xml.to_s(:indent => true)
    end
    def code
      @code ||= result['code'].to_i
    end
    def message
      @message ||= result.find('e:msg/text()').first.content.strip
    end
    private
      def result
        @result ||= @xml.find('/e:epp/e:response/e:result').first
      end
  end
end
