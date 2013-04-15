require 'helper'

class TestEppClient < Test::Unit::TestCase
  context 'EPP::Client' do
    setup do
      stub_getaddrinfo!

      @client = EPP::Client.new('TEST', 'test', 'epp.test.host')
    end

    should 'be instance of EPP::Client' do
      assert @client.kind_of?(EPP::Client)
    end

    should 'allow configuration of port' do
      stub_getaddrinfo!(nil, 7001)

      client = nil
      assert_nothing_raised do
        client = EPP::Client.new('TEST', 'test', 'epp.test.host', :port => 7001)
      end

      assert_equal 7001, client.instance_variable_get("@conn").options[:port]
    end

    should 'allow configuration of language' do
      client = EPP::Client.new('TEST', 'test', 'epp.test.host', :lang => 'no')

      assert_equal 'no', client.instance_variable_get("@conn").options[:lang]
    end

    should 'allow configuration of version' do
      client = EPP::Client.new('TEST', 'test', 'epp.test.host', :version => '2.0')

      assert_equal '2.0', client.instance_variable_get("@conn").options[:version]
    end

    should 'allow configuration of extensions' do
      extensions = %w(urn:ietf:params:xml:ns:secDNS-1.1)
      client = EPP::Client.new('TEST', 'test', 'epp.test.host', :extensions => extensions)

      assert_equal extensions, client.instance_variable_get("@conn").options[:extensions]
    end

    should 'allow configuration of services' do
      services = %w(http://www.nominet.org.uk/epp/xml/nom-domain-2.0)
      client = EPP::Client.new('TEST', 'test', 'epp.test.host', :services => services)

      assert_equal services, client.instance_variable_get("@conn").options[:services]
    end
  end
end
