require 'rubygems'
require 'epp-client'

client = EPP::Client.new('USERNAME', 'password', 'epp.test.host')

command = EPP::Host::Create.new('ns1.example.com',
  ipv4: "198.51.100.53",
  ipv6: "2001:db8::53:1"
)

resp = client.create command
result = EPP::Host::CreateResponse.new(resp)
result.name           #=> "ns1.example.com"
result.creation_date  #=> 2014-11-27 11:15:04 +0000
