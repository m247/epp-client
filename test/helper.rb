require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha/setup'

if RUBY_VERSION >= '1.9'
  begin
    require 'simplecov'
  rescue LoadError
    puts "Coverage results will not be available during this build"
  end
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'epp-client'

# Load EVERYTHING so SimpleCov works
EPP::constants.each do |constant|
  konstant = EPP::const_get(constant)
  case konstant
  when Class, Module
    konstant::constants.each do |k2|
      konstant::const_get(k2)
    end
  end
end

class Test::Unit::TestCase
  def stub_getaddrinfo!(host = 'epp.test.host', port = 700)
    host ||= 'epp.test.host'
    port ||= 700

    addrinfo = [["AF_INET", port, "198.51.100.53", "198.51.100.53", 2, 1, 6]]
    Socket.expects(:getaddrinfo).with(host, port, nil, Socket::SOCK_STREAM).returns(addrinfo).at_least_once
  end
  def load_xml(name)
    xml_path = File.expand_path("../fixtures/responses/#{name}.xml", __FILE__)
    File.read(xml_path)
  end
  def load_schema(name)
    xsd_path = File.expand_path("../support/schemas/#{name}.xsd", __FILE__)
    xsd_doc  = XML::Document.file(xsd_path)
    XML::Schema.document(xsd_doc)
  end
  def schema
    @schema ||= load_schema('all')
  end
  def xpath_find(query)
    n = @xml.find(query, @namespaces).first
    case n
    when XML::Node
      n.content.strip
    when XML::Attr
      n.value.strip
    end
  end
  def xpath_each(query)
    @xml.find(query, @namespaces).each do |node|
      yield node
    end
  end
  def xpath_exists?(query)
    !@xml.find(query, @namespaces).empty?
  end
  def namespaces_from_request(request = @request)
    @namespaces = Hash[*request.namespaces.map { |k,ns| [k, ns.href] }.flatten]
  end
end
