require File.expand_path('../command', __FILE__)

module EPP
  module Domain
    class Transfer < Command
      # @auth_info[:ext] should be an XML::Node with whatever is required
      def initialize(name, period = nil, auth_info = {})
        @name = name
        @period = period
        @auth_info = auth_info
      end

      def name
        'transfer'
      end

      def to_xml
        node = super
        node << domain_node('name', @name)
        node << period_to_xml(@period) if @period
        node << auth_info_to_xml(@auth_info) unless @auth_info.empty?

        node
      end
    end
  end
end
