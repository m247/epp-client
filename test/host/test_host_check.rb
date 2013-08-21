require 'helper'

class TestEppHostCheckCommand < Test::Unit::TestCase
  context 'EPP::Host::Check' do
    setup do
      @host_check = EPP::Host::Check.new('ns1.example.com', 'ns2.example.com')

      @check   = EPP::Commands::Check.new(@host_check)
      @command = EPP::Requests::Command.new('ABC-123', @check)
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

    should 'set names' do
      names = []
      xpath_each('//host:name') do |node|
        names << node.content.strip
      end

      assert_equal %w(ns1.example.com ns2.example.com), names
    end
  end
end
