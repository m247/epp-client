require 'helper'

class TestEppDomainInfoCommand < Test::Unit::TestCase
  context 'EPP::Domain::Info' do
    setup do
      @domain_info = EPP::Domain::Info.new('example.com')

      @info    = EPP::Commands::Info.new(@domain_info)
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

    should 'set example.com as name' do
      assert_equal 'example.com', xpath_find('//domain:name')
    end
  end
end
