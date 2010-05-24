module EPP
  class HelloRequest < Request
    def initialize
      xml.root << XML::Node.new('hello')
    end
  end
end
