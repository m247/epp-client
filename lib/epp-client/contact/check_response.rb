require File.expand_path('../response', __FILE__)

module EPP
  module Contact
    class CheckResponse < Response
      def available?(id = nil)
        return availability[id] if id

        if id.nil? && availability.count == 1
          return availability.values.first
        end

        raise ArgumentError, "id must be specified if more than one contact checked"
      end
      def unavailable?(id = nil)
        !available?(id)
      end

      def ids
        availability.keys
      end

      def id
        raise "id unavailable when more than one contact checked, use #ids" if count != 1
        ids.first
      end

      def count
        availability.count
      end

      protected
        def availability
          @availability ||= nodes_for_xpath('//contact:id').inject({}) do |hash, node|
            hash[node.content.strip] = node['avail'] == '1'
            hash
          end
        end
    end
  end
end
