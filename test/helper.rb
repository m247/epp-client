require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha/setup'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'epp-client'


class Test::Unit::TestCase
  def stub_getaddrinfo!(host = 'epp.test.host', port = 700)
    host ||= 'epp.test.host'
    port ||= 700

    addrinfo = [["AF_INET", port, "198.51.100.53", "198.51.100.53", 2, 1, 6]]
    Socket.expects(:getaddrinfo).with(host, port, nil, Socket::SOCK_STREAM).returns(addrinfo).at_least_once
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
    @xml.find(query, @namespaces).first.content.strip
  end
  def xpath_each(query)
    @xml.find(query, @namespaces).each do |node|
      yield node
    end
  end
end
