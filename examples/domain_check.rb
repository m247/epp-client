require 'rubygems'
require 'epp-client'

client = EPP::Client.new('USERNAME', 'password', 'epp.test.host')

resp  = client.check EPP::Domain::Check.new('example.com', 'example.net', 'example.org')
check = EPP::Domain::CheckResponse.new(resp)

check.available?('example.com') #=> true
check.available?('example.net') #=> false
check.available?('example.org') #=> false
