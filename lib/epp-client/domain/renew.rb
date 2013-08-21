require File.expand_path('../command', __FILE__)

module EPP
  module Domain
    class Renew < Command
      def initialize(name, exp_date, period = nil)
        @name, @exp_date = name, exp_date
        @exp_date = Time.parse(exp_date) if exp_date.kind_of?(String)

        @period_unit = period[-1,1]
        @period_val  = period.to_i.to_s
      end

      def name
        'renew'
      end

      def to_xml
        node = super
        node << domain_node('name', @name)
        node << domain_node('curExpDate', @exp_date.strftime("%Y-%m-%d"))

        p = domain_node('period', @period_val)
        p['unit'] = @period_unit

        node << p

        node
      end
    end
  end
end
