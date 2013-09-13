require 'helper'

class TestEppHostDeleteCommand < Test::Unit::TestCase
  context 'EPP::Host::Delete' do
    setup do
      @host_info = EPP::Host::Delete.new('ns1.example.com')

      @info    = EPP::Commands::Delete.new(@host_info)
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

    should 'set ns1.example.com as name' do
      assert_equal 'ns1.example.com', xpath_find('//host:name')
    end
  end
end
