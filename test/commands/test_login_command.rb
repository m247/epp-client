require 'helper'

class TestEppLoginCommand < Test::Unit::TestCase
  context 'EPP::Commands::Login' do
    setup do
      @options = {:lang => 'en', :version => '1.0',
        :services => EPP::Client::DEFAULT_SERVICES,
        :extensions => ['http://www.nominet.org.uk/epp/xml/domain-nom-ext-1.2']}

      @login   = EPP::Commands::Login.new('TEST', 'testing', @options)
      @command = EPP::Requests::Command.new('ABC-123', @login)
      @request = EPP::Request.new(@command)

      @xml = @request.to_xml

      namespaces_from_request
    end

    should 'validate against schema' do
      assert @xml.validate_schema(schema)
    end

    should 'set clTRID' do
      assert_equal 'ABC-123', xpath_find('//epp:clTRID')
    end

    should 'set TEST as clID' do
      assert_equal 'TEST', xpath_find('//epp:clID')
    end
    should 'set testing as pw' do
      assert_equal 'testing', xpath_find('//epp:pw')
    end
    should 'set 1.0 as version' do
      assert_equal '1.0', xpath_find('//epp:version')
    end
    should 'set en as lang' do
      assert_equal 'en', xpath_find('//epp:lang')
    end
    should 'set services' do
      services = []
      xpath_each('//epp:svcs/epp:objURI') do |node|
        services << node.content
      end

      assert_equal services, @options[:services]
    end
    should 'set service extensions' do
      extensions = []
      xpath_each('//epp:svcs/epp:svcExtension/epp:extURI') do |node|
        extensions << node.content
      end

      assert_equal extensions, @options[:extensions]
    end
  end
end
