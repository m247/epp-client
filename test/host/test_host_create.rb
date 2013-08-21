require 'helper'

class TestEppHostCreateCommand < Test::Unit::TestCase
  context 'EPP::Host::Create' do
    setup do
      @host_create = EPP::Host::Create.new('ns1.example.com',
        :ipv4 => "198.51.100.53", :ipv6 => "2001:db8::53:1")

      @create  = EPP::Commands::Create.new(@host_create)
      @command = EPP::Requests::Command.new('ABC-123', @create)
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

    should 'set IPv4 address' do
      assert_equal "198.51.100.53", xpath_find('//host:addr[@ip="v4"]')
    end
    
    should 'set IPv6 address' do
      assert_equal "2001:db8::53:1", xpath_find('//host:addr[@ip="v6"]')
    end
  end
end
