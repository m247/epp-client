require File.expand_path('../response', __FILE__)

module EPP
  module Host
    class CheckResponse < Response
      def available?(name = nil)
        return availability[name] if name

        if name.nil? && availability.count == 1
          return availability.values.first
        end

        raise ArgumentError, "name must be specified if more than one host checked"
      end
      def unavailable?(name = nil)
        !available?(name)
      end

      def names
        availability.keys
      end

      def name
        raise "name unavailable when more than one host checked, use #names" if count != 1
        names.first
      end

      def count
        availability.count
      end

      protected
        def availability
          @availability ||= nodes_for_xpath('//host:name').inject({}) do |hash, node|
            hash[node.content.strip] = node['avail'] == '1'
            hash
          end
        end
    end
  end
end
