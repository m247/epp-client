require File.expand_path('../read_write_command', __FILE__)

module EPP
  module Commands
    class Info < ReadWriteCommand
      def name
        'info'
      end
    end
  end
end
