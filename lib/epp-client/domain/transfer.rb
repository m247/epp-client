require File.expand_path('../command', __FILE__)

module EPP
  module Domain
    class Transfer < Command
      # @auth_info[:ext] should be an XML::Node with whatever is required
      def initialize(name, period = nil, auth_info = {})
        @name = name
        @auth_info = auth_info
        
        if period
          @period_val, @period_unit = validate_period(period)
        end
      end

      def name
        'transfer'
      end

      def to_xml
        node = super
        node << domain_node('name', @name)

        if @period_val && @period_unit
          p = domain_node('period', @period_val)
          p['unit'] = @period_unit

          node << p
        end

        node << auth_info_to_xml(@auth_info) unless @auth_info.empty?

        node
      end
    end
  end
end
