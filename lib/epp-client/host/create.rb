require File.expand_path('../command', __FILE__)

module EPP
  module Host
    class Create < Command
      def initialize(name, addrs = {})
        @name = name
        @addrs = addrs
      end

      def name
        'create'
      end

      def to_xml
        node = super
        node << host_node('name', @name)
        addrs_to_xml(node, @addrs)

        node
      end
    end
  end
end
