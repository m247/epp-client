require 'rubygems'
require 'epp-client'

client = EPP::Client.new('USERNAME', 'password', 'epp.test.host')

command = EPP::Domain::Create.new('example.com',
  period: '1y', registrant: 'test9023742684',
  auth_info: { pw: 'domainpassword' },
  contacts: { admin: 'admin123', tech: 'admin123', billing: 'admin123' },
  nameservers: [
    {name: 'ns1.example.com', ipv4: '198.51.100.53'}
    {name: 'ns2.example.com', ipv4: '198.51.100.54'}
  ]
)

resp = client.create command
result = EPP::Domain::CreateResponse.new(resp)
result.name             #=> "example.com"
result.expiration_date  #=> 2014-11-27 11:15:04 +0000
