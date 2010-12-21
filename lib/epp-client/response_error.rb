module EPP
  # Error response
  class ResponseError < RuntimeError
    attr_accessor :code, :xml
    # Create new ResponseError
    def initialize(code, msg, xml)
      super(msg)
      @code, @xml = code, xml
    end
    # @return [String] Formatted Response error
    def message
      "#{to_s} (code #{code})"
    end
  end
end
