require 'openssl'
require 'socket'
require 'xml'

require File.expand_path('../epp-client/version', __FILE__)

# EPP Module
module EPP
  # Generic error class for all EPP errors
  class Error < RuntimeError; end
end

require File.expand_path('../epp-client/xml_helper.rb',     __FILE__)

# Require typically required source files
require File.expand_path('../epp-client/client',            __FILE__)
require File.expand_path('../epp-client/server.rb',         __FILE__)
require File.expand_path('../epp-client/request.rb',        __FILE__)
require File.expand_path('../epp-client/response.rb',       __FILE__)
require File.expand_path('../epp-client/response_error.rb', __FILE__)

# Autoload less frequently required source files
module EPP
  module Requests
    autoload :Hello,     File.expand_path('../epp-client/requests/hello.rb',     __FILE__)
  end


end
