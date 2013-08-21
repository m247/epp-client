require 'helper'

class TestEppUpdateCommand < Test::Unit::TestCase
  context 'EPP::Commands::Update' do
    setup do
      @domain_update = EPP::Domain::Update.new('example.com',
        :add => {:ns => %w(ns1.test.host ns2.test.host)},
        :rem => {:ns => %w(ns3.test.host ns4.test.host)},
        :chg => {
          :registrant => 'UK-2349723',
          :auth_info => {:pw => '2381728348'}
        })

      @update  = EPP::Commands::Update.new(@domain_update)
      @command = EPP::Requests::Command.new('ABC-123', @update)
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

    should 'add nameservers' do
      nameservers = []
      xpath_each('//domain:add/domain:ns/domain:hostObj') do |node|
        nameservers << node.content.strip
      end

      assert_equal %w(ns1.test.host ns2.test.host), nameservers
    end

    should 'remove nameservers' do
      nameservers = []
      xpath_each('//domain:rem/domain:ns/domain:hostObj') do |node|
        nameservers << node.content.strip
      end

      assert_equal %w(ns3.test.host ns4.test.host), nameservers
    end

    should 'set registant for change' do
      assert_equal 'UK-2349723', xpath_find('//domain:chg/domain:registrant')
    end

    should 'set authInfo for change' do
      assert_equal '2381728348', xpath_find('//domain:chg/domain:authInfo/domain:pw')
    end
  end
end
