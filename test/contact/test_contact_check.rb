require 'helper'

class TestEppContactCheckCommand < Test::Unit::TestCase
  context 'EPP::Contact::Check' do
    setup do
      @contact_check = EPP::Contact::Check.new('UK-39246923864', 'UK-23489239')

      @check   = EPP::Commands::Check.new(@contact_check)
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

    should 'set ids' do
      ids = []
      xpath_each('//contact:id') do |node|
        ids << node.content.strip
      end

      assert_equal %w(UK-39246923864 UK-23489239), ids
    end
  end
end
