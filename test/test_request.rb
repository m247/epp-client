require 'helper'

class TestEppRequest < Test::Unit::TestCase
  context 'EPP::Request' do
    setup do
      @request = EPP::Request.new('info', 'TESTING-123') do |cmd, ext|
        info = XML::Node.new('info')
        info.namespaces.namespace = ns = XML::Namespace.new(info, 'domain', 'urn:ietf:params:xml:ns:domain-1.0')

        info << XML::Node.new('name', 'testing.com', ns)

        cmd << info
      end
    end

    should 'be info command' do
      assert_equal 'info', @request.command
    end

    should 'validate against schema' do
      xml = @request.to_xml
      assert xml.validate_schema(schema)
    end
  end
end
