require 'rubygems'
require 'epp-client'

client = EPP::Client.new('USERNAME', 'password', 'epp.test.host')

resp = client.info EPP::Domain::Info.new('example.com')
info = EPP::Domain::InfoResponse.new(resp)
info.name         #=> "example.com"
info.nameservers  #=> [{"name"=>"ns1.example.net"},{"name"=>"ns2.example.net"}]
