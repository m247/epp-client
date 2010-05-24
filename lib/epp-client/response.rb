module EPP
  class Response
    def initialize(xml_string)
      @xml = XML::Parser.string(xml_string).parse
      @xml.root.namespaces.default_prefix = 'e'
    end

    def success?
      code == 1000
    end

    def code
      @code ||= result['code'].to_i
    end
    def message
      @message ||= result.find('e:msg/text()').first.content.strip
    end
    def data
      @data ||= @xml.find('/e:epp/e:response/e:resData/node()')[1]
    end
    def msgQ
      @msgQ ||= @xml.find('/e:epp/e:response/e:msgQ').first
    end

    def inspect
      @xml.inspect
    end
    def to_xml
      @xml.to_s(:indent => true)
    end

    private
      def result
        @result ||= @xml.find('/e:epp/e:response/e:result').first
      end
  end
end
