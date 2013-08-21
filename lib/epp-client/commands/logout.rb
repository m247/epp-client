require File.expand_path('../command', __FILE__)

module EPP
  module Commands
    class Logout < Command
      def name
        'logout'
      end
    end
  end
end
