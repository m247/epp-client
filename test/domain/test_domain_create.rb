require 'helper'

class TestEppDomainCreateCommand < Test::Unit::TestCase
  context 'EPP::Domain::Create' do
    setup do
      @domain_create = EPP::Domain::Create.new('example.com',
        :period => '2y', :registrant => 'UK-2349723',
        :nameservers => %w(ns1.test.host ns2.test.host),
        :auth_info => {:pw => '2381728348'})

      @create  = EPP::Commands::Create.new(@domain_create)
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

    should 'set example.com as name' do
      assert_equal 'example.com', xpath_find('//domain:name')
    end

    should 'set period' do
      assert_equal '2', xpath_find('//domain:period')
      assert_equal 'y', xpath_find('//domain:period/@unit')
    end

    should 'set registrant' do
      assert_equal 'UK-2349723', xpath_find('//domain:registrant')
    end

    should 'set nameservers' do
      nameservers = []
      xpath_each('//domain:ns/domain:hostObj') do |node|
        nameservers << node.content.strip
      end

      assert_equal %w(ns1.test.host ns2.test.host), nameservers
    end

    should 'set authInfo' do
      assert_equal '2381728348', xpath_find('//domain:authInfo/domain:pw')
    end
  end
  
  # Outside context for Ruby 1.8
  def create_period(period)
    EPP::Domain::Create.new('example.com',
      :period => period, :registrant => 'UK-2349723',
      :nameservers => %w(ns1.test.host ns2.test.host),
      :auth_info => {:pw => '2381728348'})
  end
  context 'EPP::Domain::Create period' do
    should 'accept 1m' do
      assert_nothing_raised do
        create_period '1m'
      end
    end
    should 'accept 1y' do
      assert_nothing_raised do
        create_period '1m'
      end
    end
    should 'accept 99m' do
      assert_nothing_raised do
        create_period '1m'
      end
    end
    should 'accept 99y' do
      assert_nothing_raised do
        create_period '1m'
      end
    end
    should 'reject 0m' do
      assert_raises ArgumentError do
        create_period '0m'
      end
    end
    should 'reject 100m' do
      assert_raises ArgumentError do
        create_period '100m'
      end
    end
    should 'reject 0y' do
      assert_raises ArgumentError do
        create_period '0y'
      end
    end
    should 'reject 100y' do
      assert_raises ArgumentError do
        create_period '100y'
      end
    end
    should 'reject 12c' do
      assert_raises ArgumentError do
        create_period '12c'
      end
    end
  end
end
