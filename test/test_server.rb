require 'helper'

class TestEppServer < Test::Unit::TestCase
  context 'EPP::Server' do
    context 'DEFAULT_SERVICES' do
      should 'return EPP::Client::DEFAULT_SERVICES' do
        assert_output '', /EPP::Server::DEFAULT_SERVICES has been deprecated/ do
          assert_equal EPP::Client::DEFAULT_SERVICES, EPP::Server::DEFAULT_SERVICES
        end
      end
    end
    context '.new' do
      setup do
        @server = EPP::Server.new('TEST', 'test', 'epp.test.host')
      end
  
      should 'be instance of EPP::Server' do
        assert @server.kind_of?(EPP::Server)
      end
 
      should 'allow configuration of port' do
        server = nil
        assert_nothing_raised do
          server = EPP::Server.new('TEST', 'test', 'epp.test.host', :port => 7001)
        end
  
        assert_equal 7001, server.options[:port]
      end
  
      should 'allow configuration of language' do
        server = EPP::Server.new('TEST', 'test', 'epp.test.host', :lang => 'no')
  
        assert_equal 'no', server.options[:lang]
      end
  
      should 'allow configuration of version' do
        server = EPP::Server.new('TEST', 'test', 'epp.test.host', :version => '2.0')
  
        assert_equal '2.0', server.options[:version]
      end
  
      should 'allow configuration of extensions' do
        extensions = %w(urn:ietf:params:xml:ns:secDNS-1.1)
        server = EPP::Server.new('TEST', 'test', 'epp.test.host', :extensions => extensions)
  
        assert_equal extensions, server.options[:extensions]
      end
  
      should 'allow configuration of services' do
        services = %w(http://www.nominet.org.uk/epp/xml/nom-domain-2.0)
        server = EPP::Server.new('TEST', 'test', 'epp.test.host', :services => services)
  
        assert_equal services, server.options[:services]
      end
    end
  end
end
