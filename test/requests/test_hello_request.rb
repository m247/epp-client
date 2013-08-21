require 'helper'

class TestEppHelloRequest < Test::Unit::TestCase
  context 'EPP::Requests::Hello' do
    setup do
      @hello   = EPP::Requests::Hello.new
      @request = EPP::Request.new(@hello)
    end

    should 'validate against schema' do
      xml = @request.to_xml
      assert xml.validate_schema(schema)
    end
  end
end
