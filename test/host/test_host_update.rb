require 'helper'

class TestEppHostUpdateCommand < Test::Unit::TestCase
  context 'EPP::Host::Update' do
    setup do
      @host_update = EPP::Host::Update.new('ns1.example.com',
        :add => {
          :addr => {:ipv4 => "198.51.100.53", :ipv6 => "2001:db8::53:1"},
          :status => {:ok => "Okie Dokie"}},
        :rem => {
          :addr => {:ipv4 => "198.51.100.54", :ipv6 => "2001:db8::53:2"},
          :status => {:ok => ["Okie Dokie", "en"]}},
        :chg => {
          :name => "ns2.example.com"
        })

      @update  = EPP::Commands::Update.new(@host_update)
      @command = EPP::Requests::Command.new('ABC-123', @update)
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

    should 'add IPv4 address' do
      assert_equal "198.51.100.53", xpath_find('//host:add/host:addr[@ip="v4"]')
    end
    
    should 'add IPv6 address' do
      assert_equal "2001:db8::53:1", xpath_find('//host:add/host:addr[@ip="v6"]')
    end

    should 'add status' do
      assert_equal "Okie Dokie", xpath_find('//host:add/host:status')
      assert_equal "ok", xpath_find('//host:add/host:status/@s')
    end

    should 'remove IPv4 address' do
      assert_equal "198.51.100.54", xpath_find('//host:rem/host:addr[@ip="v4"]')
    end
    
    should 'remove IPv6 address' do
      assert_equal "2001:db8::53:2", xpath_find('//host:rem/host:addr[@ip="v6"]')
    end

    should 'remove status' do
      assert_equal "Okie Dokie", xpath_find('//host:rem/host:status')
      assert_equal "en", xpath_find('//host:rem/host:status/@lang')
      assert_equal "ok", xpath_find('//host:rem/host:status/@s')
    end
    
    should 'change name' do
      assert_equal 'ns2.example.com', xpath_find('//host:chg/host:name')
    end
  end
end
