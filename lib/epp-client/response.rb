module EPP
  # An EPP XML Response
  class Response
    # Creates an instance of an EPP::Response
    #
    # @param [String] xml_string XML Response
    def initialize(xml_string)
      @xml = XML::Parser.string(xml_string).parse
      @xml.root.namespaces.default_prefix = 'e'
    end

    # Indicates if the response is successful.
    # @return [Boolean] if the response is successful
    def success?
      code == 1000
    end

    # Response code
    # @return [Integer] response code
    def code
      @code ||= result['code'].to_i
    end

    # Response message
    # @return [String] response message
    def message
      @message ||= result.find('e:msg/text()').first.content.strip
    end

    # Descriptive Error Information
    # @return [XML::Node] error information
    def error_value
      @error_value ||= result.find('e:extValue/e:value/node()').first
    end

    # Error reason
    # @return [String] error reason
    def error_reason
      @error_reason ||= result.find('e:extValue/e:reason/text()').first.content.strip
    end

    # Response data
    # @return [XML::Node, Array<XML::Node>] response data
    def data
      @data ||= begin
        list = @xml.find('/e:epp/e:response/e:resData/node()').reject { |n| n.empty? }
        list.size > 1 ? list : list[0]
      end
    end

    # Response Message Queue
    # @return [XML::Node] message queue
    def msgQ
      @msgQ ||= @xml.find('/e:epp/e:response/e:msgQ').first
    end

    # Response extension block
    # @return [XML::Node, Array<XML::Node>] extension
    def extension
      @extension ||= begin
        list = @xml.find('/e:epp/e:response/e:extension/node()').reject { |n| n.empty? }
        list.size > 1 ? list : list[0]
      end
    end

    # @see Object#inspect
    def inspect
      @xml.inspect
    end

    # Returns a the formatted response XML
    # @return [String] formatted XML response
    def to_xml
      @xml.to_s(:indent => true)
    end

    private
      # @return [XML::Node] Result node
      def result
        @result ||= @xml.find('/e:epp/e:response/e:result').first
      end
  end
end
