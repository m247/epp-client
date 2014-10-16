require 'helper'

class TestEppDomainTransferCommand < Test::Unit::TestCase
  context 'EPP::Domain::Transfer' do
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

  # Outside context for Ruby 1.8
  def transfer_period(period)
    EPP::Domain::Transfer.new('example.com', period, :pw => '2381728348')
  end
  context 'EPP::Domain::Transfer period' do
    should 'accept 1m' do
      assert_nothing_raised do
        transfer_period '1m'
      end
    end
    should 'accept 1y' do
      assert_nothing_raised do
        transfer_period '1m'
      end
    end
    should 'accept 99m' do
      assert_nothing_raised do
        transfer_period '1m'
      end
    end
    should 'accept 99y' do
      assert_nothing_raised do
        transfer_period '1m'
      end
    end
    should 'reject 0m' do
      assert_raises ArgumentError do
        transfer_period '0m'
      end
    end
    should 'reject 100m' do
      assert_raises ArgumentError do
        transfer_period '100m'
      end
    end
    should 'reject 0y' do
      assert_raises ArgumentError do
        transfer_period '0y'
      end
    end
    should 'reject 100y' do
      assert_raises ArgumentError do
        transfer_period '100y'
      end
    end
    should 'reject 12c' do
      assert_raises ArgumentError do
        transfer_period '12c'
      end
    end
  end
end
