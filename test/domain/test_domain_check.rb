require 'helper'

class TestEppDomainCheckCommand < Test::Unit::TestCase
  context 'EPP::Domain::Check' do
    setup do
      @domain_check = EPP::Domain::Check.new('example.com', 'example.net')

      @check   = EPP::Commands::Check.new(@domain_check)
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
      xpath_each('//domain:name') do |node|
        names << node.content.strip
      end

      assert_equal %w(example.com example.net), names
    end
  end
end
