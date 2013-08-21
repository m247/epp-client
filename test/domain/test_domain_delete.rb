require 'helper'

class TestEppDomainDeleteCommand < Test::Unit::TestCase
  context 'EPP::Domain::Delete' do
    setup do
      @domain_delete = EPP::Domain::Delete.new('example.com')

      @delete  = EPP::Commands::Delete.new(@domain_delete)
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
      assert_equal 'example.com', xpath_find('//domain:name')
    end
  end
end
