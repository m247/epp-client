module EPP
  class ResponseError < RuntimeError
    attr_accessor :code, :xml
    def initialize(code, msg, xml)
      super(msg)
      @code, @xml = code, xml
    end
    def to_s
      "#{message} (code #{code})"
    end
  end
end
