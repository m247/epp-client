require File.expand_path('../read_write_command', __FILE__)

module EPP
  module Commands
    class Renew < ReadWriteCommand
      def name
        'renew'
      end
    end
  end
end
