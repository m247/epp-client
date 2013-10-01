require 'openssl'
require 'socket'
require 'time'
require 'xml'

require File.expand_path('../epp-client/version', __FILE__)

# EPP Module
module EPP
  # Generic error class for all EPP errors
  class Error < RuntimeError; end
end

require File.expand_path('../epp-client/xml_helper.rb',     __FILE__)
require File.expand_path('../epp-client/response_helper.rb',                     __FILE__)

module EPP
  autoload :OldServer, File.expand_path('../epp-client/old_server.rb',    __FILE__)

  module Requests
    autoload :Hello,     File.expand_path('../epp-client/requests/hello.rb',     __FILE__)
    autoload :Command,   File.expand_path('../epp-client/requests/command.rb',   __FILE__)
    autoload :Extension, File.expand_path('../epp-client/requests/extension.rb', __FILE__)
  end

  module Commands
    autoload :Check,    File.expand_path('../epp-client/commands/check.rb',    __FILE__)
    autoload :Create,   File.expand_path('../epp-client/commands/create.rb',   __FILE__)
    autoload :Delete,   File.expand_path('../epp-client/commands/delete.rb',   __FILE__)
    autoload :Info,     File.expand_path('../epp-client/commands/info.rb',     __FILE__)
    autoload :Login,    File.expand_path('../epp-client/commands/login.rb',    __FILE__)
    autoload :Logout,   File.expand_path('../epp-client/commands/logout.rb',   __FILE__)
    autoload :Poll,     File.expand_path('../epp-client/commands/poll.rb',     __FILE__)
    autoload :Renew,    File.expand_path('../epp-client/commands/renew.rb',    __FILE__)
    autoload :Transfer, File.expand_path('../epp-client/commands/transfer.rb', __FILE__)
    autoload :Update,   File.expand_path('../epp-client/commands/update.rb',   __FILE__)
  end

  module Domain
    NAMESPACE       = 'urn:ietf:params:xml:ns:domain-1.0'
    SCHEMA_LOCATION = 'urn:ietf:params:xml:ns:domain-1.0 domain-1.0.xsd'

    autoload :Check,    File.expand_path('../epp-client/domain/check.rb',     __FILE__)
    autoload :Create,   File.expand_path('../epp-client/domain/create.rb',    __FILE__)
    autoload :Delete,   File.expand_path('../epp-client/domain/delete.rb',    __FILE__)
    autoload :Info,     File.expand_path('../epp-client/domain/info.rb',      __FILE__)
    autoload :Renew,    File.expand_path('../epp-client/domain/renew.rb',     __FILE__)
    autoload :Transfer, File.expand_path('../epp-client/domain/transfer.rb',  __FILE__)
    autoload :Update,   File.expand_path('../epp-client/domain/update.rb',    __FILE__)

    autoload :CheckResponse,    File.expand_path('../epp-client/domain/check_response.rb',     __FILE__)
    autoload :CreateResponse,   File.expand_path('../epp-client/domain/create_response.rb',    __FILE__)
    autoload :DeleteResponse,   File.expand_path('../epp-client/domain/delete_response.rb',    __FILE__)
    autoload :InfoResponse,     File.expand_path('../epp-client/domain/info_response.rb',      __FILE__)
    autoload :RenewResponse,    File.expand_path('../epp-client/domain/renew_response.rb',     __FILE__)
    autoload :TransferResponse, File.expand_path('../epp-client/domain/transfer_response.rb',  __FILE__)
    autoload :UpdateResponse,   File.expand_path('../epp-client/domain/update_response.rb',    __FILE__)
  end

  module Contact
    NAMESPACE       = 'urn:ietf:params:xml:ns:contact-1.0'
    SCHEMA_LOCATION = 'urn:ietf:params:xml:ns:contact-1.0 contact-1.0.xsd'

    autoload :Check,    File.expand_path('../epp-client/contact/check.rb',     __FILE__)
    autoload :Create,   File.expand_path('../epp-client/contact/create.rb',    __FILE__)
    autoload :Delete,   File.expand_path('../epp-client/contact/delete.rb',    __FILE__)
    autoload :Info,     File.expand_path('../epp-client/contact/info.rb',      __FILE__)
    autoload :Transfer, File.expand_path('../epp-client/contact/transfer.rb',  __FILE__)
    autoload :Update,   File.expand_path('../epp-client/contact/update.rb',    __FILE__)

    autoload :CheckResponse,    File.expand_path('../epp-client/contact/check_response.rb',     __FILE__)
    autoload :CreateResponse,   File.expand_path('../epp-client/contact/create_response.rb',    __FILE__)
    autoload :DeleteResponse,   File.expand_path('../epp-client/contact/delete_response.rb',    __FILE__)
    autoload :InfoResponse,     File.expand_path('../epp-client/contact/info_response.rb',      __FILE__)
    autoload :TransferResponse, File.expand_path('../epp-client/contact/transfer_response.rb',  __FILE__)
    autoload :UpdateResponse,   File.expand_path('../epp-client/contact/update_response.rb',    __FILE__)
  end

  module Host
    NAMESPACE       = 'urn:ietf:params:xml:ns:host-1.0'
    SCHEMA_LOCATION = 'urn:ietf:params:xml:ns:host-1.0 host-1.0.xsd'

    autoload :Check,    File.expand_path('../epp-client/host/check.rb',     __FILE__)
    autoload :Create,   File.expand_path('../epp-client/host/create.rb',    __FILE__)
    autoload :Delete,   File.expand_path('../epp-client/host/delete.rb',    __FILE__)
    autoload :Info,     File.expand_path('../epp-client/host/info.rb',      __FILE__)
    autoload :Update,   File.expand_path('../epp-client/host/update.rb',    __FILE__)

    autoload :CheckResponse,    File.expand_path('../epp-client/host/check_response.rb',     __FILE__)
    autoload :CreateResponse,   File.expand_path('../epp-client/host/create_response.rb',    __FILE__)
    autoload :DeleteResponse,   File.expand_path('../epp-client/host/delete_response.rb',    __FILE__)
    autoload :InfoResponse,     File.expand_path('../epp-client/host/info_response.rb',      __FILE__)
    autoload :UpdateResponse,   File.expand_path('../epp-client/host/update_response.rb',    __FILE__)
  end
end

require File.expand_path('../epp-client/client',            __FILE__)
require File.expand_path('../epp-client/server.rb',         __FILE__)
require File.expand_path('../epp-client/request.rb',        __FILE__)
require File.expand_path('../epp-client/response.rb',       __FILE__)
require File.expand_path('../epp-client/response_error.rb', __FILE__)
