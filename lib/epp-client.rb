require 'openssl'
require 'socket'
require 'xml'

# EPP Module
module EPP
  autoload :Client, File.dirname(__FILE__) + '/epp-client/client.rb'
  autoload :Server, File.dirname(__FILE__) + '/epp-client/server.rb'
  autoload :OldServer, File.dirname(__FILE__) + '/epp-client/old_server.rb'
  autoload :Request, File.dirname(__FILE__) + '/epp-client/request.rb'
  autoload :Response, File.dirname(__FILE__) + '/epp-client/response.rb'
  autoload :ResponseError, File.dirname(__FILE__) + '/epp-client/response_error.rb'
  autoload :HelloRequest, File.dirname(__FILE__) + '/epp-client/hello_request.rb'
end
