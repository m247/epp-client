require 'helper'

class TestEppContactInfoCommand < Test::Unit::TestCase
  context 'EPP::Contact::Info' do
    setup do
      @contact_info = EPP::Contact::Info.new('UK-39246923864')

      @info    = EPP::Commands::Info.new(@contact_info)
      @command = EPP::Requests::Command.new('ABC-123', @info)
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

    should 'set UK-39246923864 as id' do
      assert_equal 'UK-39246923864', xpath_find('//contact:id')
    end
  end
end
