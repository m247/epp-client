require 'helper'

class TestEppCreateCommand < Test::Unit::TestCase
  context 'EPP::Commands::Create' do
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
end
