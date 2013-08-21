require File.expand_path('../command', __FILE__)

module EPP
  module Host
    class Delete < Command
      def initialize(name)
        @name = name
      end

      def name
        'delete'
      end

      def to_xml
        node = super
        node << host_node('name', @name)
        node
      end
    end
  end
end
