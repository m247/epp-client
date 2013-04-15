require 'openssl'
require 'socket'
require 'xml'

require File.expand_path('../epp-client/version', __FILE__)

# EPP Module
module EPP
  # Generic error class for all EPP errors
  class Error < RuntimeError; end

  autoload :Client,         File.expand_path('../epp-client/client.rb',         __FILE__)
  autoload :Server,         File.expand_path('../epp-client/server.rb',         __FILE__)
  autoload :OldServer,      File.expand_path('../epp-client/old_server.rb',     __FILE__)
  autoload :Request,        File.expand_path('../epp-client/request.rb',        __FILE__)
  autoload :Response,       File.expand_path('../epp-client/response.rb',       __FILE__)
  autoload :ResponseError,  File.expand_path('../epp-client/response_error.rb', __FILE__)

  autoload :HelloRequest,   File.expand_path('../epp-client/requests/hello_request.rb',  __FILE__)
end
