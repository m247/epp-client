require File.expand_path('../command', __FILE__)

module EPP
  module Contact
    class Transfer < Command
      def initialize(id)
        @id = id
      end

      def name
        'transfer'
      end

      def to_xml
        node = super
        node << contact_node('id', @id)
        node
      end
    end
  end
end
