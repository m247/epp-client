require 'helper'

class TestEppLogoutCommand < Test::Unit::TestCase
  context 'EPP::LogoutCommand' do
    setup do
      @logout  = EPP::Commands::Logout.new
      @command = EPP::Requests::Command.new('ABC-123', @logout)
      @request = EPP::Request.new(@command)
      @xml     = @request.to_xml

      namespaces_from_request
    end

    should 'validate against schema' do
      assert @xml.validate_schema(schema)
    end

    should 'set clTRID' do
      assert_equal 'ABC-123', xpath_find('//epp:clTRID')
    end
  end
end
