module EPP
  class Client
    def initialize(tag, passwd, host, options = {})
      @conn = if options.delete(:compatibility) == true
        OldServer.new(tag, passwd, host, options)
      else
        Server.new(tag, passwd, host, options)
      end
    end
    def hello
      @conn.connection do
        @conn.hello
      end
    end
    def method_missing(command, payload = nil, &block)
      @conn.connection do
        @conn.with_login do
          @conn.request(command, payload, &block)
        end
      end
    end
  end
end
