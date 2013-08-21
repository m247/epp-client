require File.expand_path('../command', __FILE__)

module EPP
  module Host
    class Info < Command
      def initialize(name)
        @name = name
      end

      def name
        'info'
      end

      def to_xml
        node = super
        node << host_node('name', @name)
        node
      end
    end
  end
end
