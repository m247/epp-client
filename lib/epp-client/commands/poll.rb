require File.expand_path('../command', __FILE__)

module EPP
  module Commands
    class Poll < Command
      def initialize(msgID = nil)
        @msgID = msgID
      end
      
      def name
        'poll'
      end

      def to_xml
        node = super

        if @msgID
          node['op'] = 'ack'
          node['msgID'] = @msgID
        else
          node['op'] = 'req'
        end

        node
      end
    end
  end
end
