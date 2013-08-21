require File.expand_path('../command', __FILE__)

module EPP
  module Contact
    class Info < Command
      def initialize(id)
        @id = id
      end

      def name
        'info'
      end

      def to_xml
        node = super
        node << contact_node('id', @id)
        node
      end
    end
  end
end
