require 'rubygems'
require 'epp-client'

client = EPP::Client.new('USERNAME', 'password', 'epp.test.host')

command = EPP::Contact::Create.new('admin123',
  postal_info: {
    name: 'Test User',
    org: 'Test Organisation',
    addr: {
      street: "Test Building\n14 Test Road",
      city: "Test City",
      sp: "Test Province",
      pc: "TE57 1NG",
      cc: "GB"
    }
  },
  voice: '+44.1614960000',
  fax: '+44.1614960001',
  email: 'user@test.host',
  auth_info: { pw: '324723984' },
  disclose: { "0" => %w(voice email)}
)

resp = client.create command
result = EPP::Contact::CreateResponse.new(resp)
result.id             #=> "admin123"
result.creation_date  #=> 2014-11-27 11:15:04 +0000
