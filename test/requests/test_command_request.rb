require 'helper'

class TestEppCommandRequest < Test::Unit::TestCase
  context 'EPP::Requests::Command' do
    setup do
      @logout  = EPP::Commands::Logout.new
      @command = EPP::Requests::Command.new('ABC-123', @logout)
      @request = EPP::Request.new(@command)
    end

    should 'validate against schema' do
      xml = @request.to_xml
      assert xml.validate_schema(schema)
    end
  end
end
