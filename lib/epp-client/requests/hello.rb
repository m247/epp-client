require File.expand_path('../abstract', __FILE__)

module EPP
  module Requests
    # An EPP Hello Request
    class Hello < Abstract
      def name
        'hello'
      end
    end
  end
end
