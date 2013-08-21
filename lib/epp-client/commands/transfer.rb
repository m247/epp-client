require File.expand_path('../read_write_command', __FILE__)

module EPP
  module Commands
    class Transfer < ReadWriteCommand
      OPERATIONS = %w(approve cancel query reject request)      
      
      def initialize(op, command)
        raise ArgumentError, "op must be one of #{OPERATIONS.join(', ')}" unless OPERATIONS.include?(op)

        super command
        @op = op
      end
      def name
        'transfer'
      end

      def to_xml
        node = super
        node['op'] = @op
        node
      end
    end
  end
end