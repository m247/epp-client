require 'helper'

class TestEppTransferCommand < Test::Unit::TestCase
  context 'EPP::Commands::Transfer' do
    setup do
      @domain_transfer = EPP::Domain::Transfer.new('example.com', '12m', :pw => '2381728348')

      @transfer = EPP::Commands::Transfer.new('query', @domain_transfer)
      @command = EPP::Requests::Command.new('ABC-123', @transfer)
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

    should 'set period' do
      assert_equal '12', xpath_find('//domain:period')
      assert_equal 'm', xpath_find('//domain:period/@unit')
    end

    should 'set authInfo' do
      assert_equal '2381728348', xpath_find('//domain:authInfo/domain:pw')
    end
  end
end
