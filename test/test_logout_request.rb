require 'helper'

class TestEppLogoutRequest < Test::Unit::TestCase
  context 'EPP::LogoutRequest' do
    setup do
      @logout_request = EPP::LogoutRequest.new
    end

    should 'be logout command' do
      assert_equal 'logout', @logout_request.command
    end

    should 'validate against schema' do
      xml = @logout_request.to_xml
      assert xml.validate_schema(schema)
    end
  end
end
