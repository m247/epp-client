require File.expand_path('../response', __FILE__)

module EPP
  module Contact
    class CheckResponse < Response
      def available?(id)
        availability[id]
      end
      def unavailable?(id)
        !available?(id)
      end

      protected
        def availability
          @availability ||= @response.data.find('//contact:id', namespaces).inject({}) do |hash, node|
            hash[node.content.strip] = node['avail'] == '1'
            hash
          end
        end
    end
  end
end
