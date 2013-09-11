require 'helper'

class TestEppExtensionRequest < Test::Unit::TestCase
  context 'EPP::Requests::Extension' do
    context 'single extension' do
      setup do
        @domain_info  = XML::Node.new('info')
        @domain_info.namespaces.namespace = ns =
          XML::Namespace.new(@domain_info, 'domain', "urn:ietf:params:xml:ns:domain-1.0")

        xattr = XML::Attr.new(@domain_info, "schemaLocation", "urn:ietf:params:xml:ns:domain-1.0 domain-1.0.xsd")
        xattr.namespaces.namespace = XML::Namespace.new(@domain_info, 'xsi', 'http://www.w3.org/2001/XMLSchema-instance')

        @domain_info << XML::Node.new('name', 'example.com', ns)

        @extension = EPP::Requests::Extension.new(@domain_info)
        @request   = EPP::Request.new(@extension)
      end

      should 'validate against schema' do
        xml = @request.to_xml
        assert xml.validate_schema(schema), xml.to_s(:indent => 2)
      end
    end
    context 'mutltiple extensions' do
      setup do
        @domain_info  = XML::Node.new('info')
        @domain_info.namespaces.namespace = ns =
          XML::Namespace.new(@domain_info, 'domain', "urn:ietf:params:xml:ns:domain-1.0")

        xattr = XML::Attr.new(@domain_info, "schemaLocation", "urn:ietf:params:xml:ns:domain-1.0 domain-1.0.xsd")
        xattr.namespaces.namespace = XML::Namespace.new(@domain_info, 'xsi', 'http://www.w3.org/2001/XMLSchema-instance')

        @domain_info << XML::Node.new('name', 'example.com', ns)

        @domain_check = XML::Node.new('check')
        @domain_check.namespaces.namespace = ns =
          XML::Namespace.new(@domain_check, 'domain', "urn:ietf:params:xml:ns:domain-1.0")

        xattr = XML::Attr.new(@domain_check, "schemaLocation", "urn:ietf:params:xml:ns:domain-1.0 domain-1.0.xsd")
        xattr.namespaces.namespace = XML::Namespace.new(@domain_check, 'xsi', 'http://www.w3.org/2001/XMLSchema-instance')

        @domain_check << XML::Node.new('name', 'example.com', ns)

        @extension = EPP::Requests::Extension.new(@domain_info, @domain_check)
        @request   = EPP::Request.new(@extension)
      end

      should 'validate against schema' do
        xml = @request.to_xml
        assert xml.validate_schema(schema), xml.to_s(:indent => 2)
      end
    end
  end
end
