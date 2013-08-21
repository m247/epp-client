require 'helper'

class TestEppContactDeleteCommand < Test::Unit::TestCase
  context 'EPP::Contact::Delete' do
    setup do
      @contact_delete = EPP::Contact::Delete.new('UK-39246923864')

      @delete  = EPP::Commands::Delete.new(@contact_delete)
      @command = EPP::Requests::Command.new('ABC-123', @delete)
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

    should 'set example.com as name' do
      assert_equal 'UK-39246923864', xpath_find('//contact:id')
    end
  end
end
