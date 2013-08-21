require 'helper'

class TestEppDomainRenewCommand < Test::Unit::TestCase
  context 'EPP::Domain::Renew' do
    setup do
      @time = Time.now
      @domain_renew = EPP::Domain::Renew.new('example.com', @time, '12m')

      @renew   = EPP::Commands::Renew.new(@domain_renew)
      @command = EPP::Requests::Command.new('ABC-123', @renew)
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

    should 'set date as curExpDate' do
      date = @time.strftime('%Y-%m-%d')
      assert_equal date, xpath_find('//domain:curExpDate')
    end

    should 'set period' do
      assert_equal '12', xpath_find('//domain:period')
      assert_equal 'm', xpath_find('//domain:period/@unit')
    end
  end
end
