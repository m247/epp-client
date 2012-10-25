# EPP Client

Client for communicating with EPP services

## Installation

Add this line to your application's Gemfile:

    gem 'epp-client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install epp-client

## Usage

    client = EPP::Client.new('username', 'password', 'epp.server.com')
    client.hello
    puts client._last_request.inspect
    puts client._last_response.inspect

Any other methods called on `client` will be passed through to an
authenticated EPP server connection. As a quick example, either a
string of XML, an XML::Node or XML::Document can be passed or a
block may be used

### domain:check using string payload

    client.check <<-EOXML
      <domain:check
       xmlns:domain="urn:ietf:params:xml:ns:domain-1.0">
        <domain:name>example.com</domain:name>
        <domain:name>example.net</domain:name>
        <domain:name>example.org</domain:name>
      </domain:check>
    EOXML

### domain:check using XML::Node payload

    xml = XML::Node.new('check')
    ns = XML::Namespace.new(xml, 'domain', 'urn:ietf:params:xml:ns:domain-1.0')
    xml.namespaces.namespace = ns

    %w(example.com example.net example.org).each do |name|
      xml << XML::Node.new('name', name, ns)
    end

    client.check xml

### domain:check using block

    client.check do |xml|
      xml << (check = XML::Node.new('check'))
      ns = XML::Namespace.new(check, 'domain', 'urn:ietf:params:xml:ns:domain-1.0')
      check.namespaces.namespace = ns

      %w(example.com example.net example.org).each do |name|
        check << XML::Node.new('name', name, ns)
      end
    end

If you leave off the block parameter then the return value of the block will be
inserted into the `xml`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
