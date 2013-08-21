require File.expand_path('../command', __FILE__)

module EPP
  module Commands
    class ReadWriteCommand < Command
      def initialize(command)
        @command = command
      end
      def to_xml
        node = super
        
        @command.set_namespaces(@namespaces) if @command.respond_to?(:set_namespaces)
        node << as_xml(@command)
        node
      end
    end
  end
end
