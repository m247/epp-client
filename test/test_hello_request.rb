require 'helper'

class TestEppHelloRequest < Test::Unit::TestCase
  context 'EPP::HelloRequest' do
    setup do
      @hello_request = EPP::HelloRequest.new
    end

    should 'validate against schema' do
      xml = @hello_request.to_xml
      assert xml.validate_schema(schema)
    end
  end
end
