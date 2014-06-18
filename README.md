# EPP Client

[![Build Status](https://travis-ci.org/m247/epp-client.svg?branch=master)](https://travis-ci.org/m247/epp-client)

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
    puts client.last_request.to_s(:indent => 2)
    puts client.last_response.to_s(:indent => 2)

The old `method_missing` behaviour has been removed and replaced with defined
methods for handling each of the distinct EPP commands.

* `check`
* `create`
* `delete`
* `info`
* `renew`
* `transfer`
* `update`
* `poll`
* `ack`

each of these methods, with the exception of `poll` and `ack`, accept two arguments.
Those arguments are a `payload` and an optional `extension`. The majority of the
common `domain`, `contact` and `host` payloads have been defined already.

### Domain Check Example

    resp = client.check EPP::Domain::Check.new('example.com', 'example.net', 'example.org')
    resp.available?('example.com') #=> true
    resp.available?('example.net') #=> false
    resp.available?('example.org') #=> false

### Domain Information Example

    resp = client.info EPP::Domain::Info.new('example.com')
    resp.name #=> "example.com"
    resp.nameservers #=> [{"name"=>"ns1.example.net"},{"name"=>"ns2.example.net"}]

### Payload an Extension API

The objects which are passed to the `client` methods need to adhere to the following
API in order to be successfully marshalled by the `client` into the required XML
document.

* `name` to specify the EPP command name. Required.
* `to_xml` returns an `XML::Document`. Required.
* `set_namespaces` to receive `XML::Namespace` objects from the parent. Optional.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
