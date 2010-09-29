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
    def to_s
      "#{message} (code #{code})"
    end
  end
end
