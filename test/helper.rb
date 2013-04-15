require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha/setup'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'epp-client'

EPP::Request.enable_validation!

class Test::Unit::TestCase
  def load_schema(name)
    xsd_path = File.expand_path("../schemas/#{name}.xsd", __FILE__)
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
