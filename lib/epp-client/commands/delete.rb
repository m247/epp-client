require File.expand_path('../read_write_command', __FILE__)

module EPP
  module Commands
    class Delete < ReadWriteCommand
      def name
        'delete'
      end
    end
  end
end
