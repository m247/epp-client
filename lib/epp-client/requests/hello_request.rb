module EPP
  # An EPP Hello Request
  class HelloRequest < Request
    # Create new HelloRequest instance
    def initialize(*ignored)
      xml.root << xml_node('hello')
    end
  end
end
