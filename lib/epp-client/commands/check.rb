require File.expand_path('../read_write_command', __FILE__)

module EPP
  module Commands
    class Check < ReadWriteCommand
      def name
        'check'
      end
    end
  end
end
