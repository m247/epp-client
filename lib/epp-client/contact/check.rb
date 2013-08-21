require File.expand_path('../command', __FILE__)

module EPP
  module Contact
    class Check < Command
      def initialize(*ids)
        @ids = ids.flatten
      end

      def name
        'check'
      end

      def to_xml
        node = super
        @ids.each do |id|
          node << contact_node('id', id)
        end
        node
      end
    end
  end
end
