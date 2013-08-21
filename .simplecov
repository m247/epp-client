SimpleCov.start do
  add_group 'Core' do |src_file|
    File.dirname(src_file.filename) =~ %r</lib(/epp-client)?$>
  end

  add_group 'Commands',     'lib/epp-client/commands'
  add_group 'Requests',     'lib/epp-client/requests'
  add_group 'Responses',    'lib/epp-client/responses'
  
  add_group 'EPP Domain',   'lib/epp-client/domain'
  add_group 'EPP Contact',  'lib/epp-client/contact'
  add_group 'EPP Host',     'lib/epp-client/host'

  add_filter '/.bundle/'
  add_filter '/test/'
end
