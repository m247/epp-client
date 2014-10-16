require File.expand_path('../command', __FILE__)

module EPP
  module Domain
    class Renew < Command
      # @param [String] name Domain name to renew
      # @param [Time,String] exp_date Expiration date of the domain
      # @param [String] period Renewal period in XXy years or XXm months. XX must be between 1 and 99.
      def initialize(name, exp_date, period = nil)
        @name, @exp_date = name, exp_date
        @exp_date = Time.parse(exp_date) if exp_date.kind_of?(String)

        if period
          @period_val, @period_unit = validate_period(period)
        end
      end

      def name
        'renew'
      end

      def to_xml
        node = super
        node << domain_node('name', @name)
        node << domain_node('curExpDate', @exp_date.strftime("%Y-%m-%d"))

        if @period_val && @period_unit
          p = domain_node('period', @period_val)
          p['unit'] = @period_unit

          node << p
        end

        node
      end
    end
  end
end
