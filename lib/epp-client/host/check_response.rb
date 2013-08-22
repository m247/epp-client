require File.expand_path('../response', __FILE__)

module EPP
  module Host
    class CheckResponse < Response
      def available?(name)
        availability[name]
      end
      def unavailable?(name)
        !available?(name)
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
