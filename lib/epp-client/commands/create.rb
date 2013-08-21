require File.expand_path('../read_write_command', __FILE__)

module EPP
  module Commands
    class Create < ReadWriteCommand
      def name
        'create'
      end
    end
  end
end
