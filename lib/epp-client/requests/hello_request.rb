module EPP
  # An EPP Hello Request
  class HelloRequest < Request
    # Create new HelloRequest instance
    def initialize(*ignored)
      xml.root << XML::Node.new('hello')
    end
  end
end
