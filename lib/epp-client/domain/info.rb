require File.expand_path('../command', __FILE__)

module EPP
  module Domain
    class Info < Command
      def initialize(name)
        @name = name
      end

      def name
        'info'
      end

      def to_xml
        node = super
        node << domain_node('name', @name)
        node
      end
    end
  end
end
