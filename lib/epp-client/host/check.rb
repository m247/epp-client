require File.expand_path('../command', __FILE__)

module EPP
  module Host
    class Check < Command
      def initialize(*names)
        @names = names.flatten
      end

      def name
        'check'
      end

      def to_xml
        node = super
        @names.each do |name|
          node << host_node('name', name)
        end
        node
      end
    end
  end
end
