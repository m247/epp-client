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
    autoload :Command,   File.expand_path('../epp-client/requests/command.rb',   __FILE__)
    autoload :Extension, File.expand_path('../epp-client/requests/extension.rb', __FILE__)
  end

  module Commands
    autoload :Check,    File.expand_path('../epp-client/commands/check.rb',    __FILE__)
    autoload :Login,    File.expand_path('../epp-client/commands/login.rb',    __FILE__)
    autoload :Logout,   File.expand_path('../epp-client/commands/logout.rb',   __FILE__)
    autoload :Poll,     File.expand_path('../epp-client/commands/poll.rb',     __FILE__)
  end

  module Domain
    autoload :Check,    File.expand_path('../epp-client/domain/check.rb',     __FILE__)
  end

end
