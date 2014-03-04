require 'helper'

class TestEppClient < Test::Unit::TestCase
  context 'EPP::Client' do
    setup do
      @client = EPP::Client.new('TEST', 'test', 'epp.test.host')
    end
  
    should 'be instance of EPP::Client' do
      assert @client.kind_of?(EPP::Client)
    end
  
    should 'allow configuration of port' do
      client = nil
      assert_nothing_raised do
        client = EPP::Client.new('TEST', 'test', 'epp.test.host', :port => 7001)
      end
  
      assert_equal 7001, client.options[:port]
    end

    should 'allow configuration of SSL context' do
        client = nil
        ctx = OpenSSL::SSL::SSLContext.new
        assert_nothing_raised do
          client = EPP::Client.new('TEST', 'test', 'epp.test.host', :ssl_context => ctx)
        end

        assert_equal ctx, client.options[:ssl_context]
      end
  
    should 'allow configuration of language' do
      client = EPP::Client.new('TEST', 'test', 'epp.test.host', :lang => 'no')
  
      assert_equal 'no', client.options[:lang]
    end
  
    should 'allow configuration of version' do
      client = EPP::Client.new('TEST', 'test', 'epp.test.host', :version => '2.0')
  
      assert_equal '2.0', client.options[:version]
    end
  
    should 'allow configuration of extensions' do
      extensions = %w(urn:ietf:params:xml:ns:secDNS-1.1)
      client = EPP::Client.new('TEST', 'test', 'epp.test.host', :extensions => extensions)
  
      assert_equal extensions, client.options[:extensions]
    end
  
    should 'allow configuration of services' do
      services = %w(http://www.nominet.org.uk/epp/xml/nom-domain-2.0)
      client = EPP::Client.new('TEST', 'test', 'epp.test.host', :services => services)
  
      assert_equal services, client.options[:services]
    end

    should 'allow compatibility mode' do
      client = EPP::Client.new('TEST', 'test', 'epp.test.host', :compatibility => true)

      assert client.compatibility?
    end
  end
end
