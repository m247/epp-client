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
  
  # Outside context for Ruby 1.8
  def renew_period(period)
    EPP::Domain::Renew.new('example.com', Time.now, period)
  end
  context 'EPP::Domain::Renew period' do
    should 'accept 1m' do
      assert_nothing_raised do
        renew_period '1m'
      end
    end
    should 'accept 1y' do
      assert_nothing_raised do
        renew_period '1m'
      end
    end
    should 'accept 99m' do
      assert_nothing_raised do
        renew_period '1m'
      end
    end
    should 'accept 99y' do
      assert_nothing_raised do
        renew_period '1m'
      end
    end
    should 'reject 0m' do
      assert_raises ArgumentError do
        renew_period '0m'
      end
    end
    should 'reject 100m' do
      assert_raises ArgumentError do
        renew_period '100m'
      end
    end
    should 'reject 0y' do
      assert_raises ArgumentError do
        renew_period '0y'
      end
    end
    should 'reject 100y' do
      assert_raises ArgumentError do
        renew_period '100y'
      end
    end
    should 'reject 12c' do
      assert_raises ArgumentError do
        renew_period '12c'
      end
    end
  end  
end
