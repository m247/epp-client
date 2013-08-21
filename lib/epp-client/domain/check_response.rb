require File.expand_path('../response', __FILE__)

module EPP
  module Domain
    class CheckResponse < Response
      def available?(name)
        availability[name]
      end
      def unavailable?(name)
        !available?(name)
      end
      
      protected
        def availability
          @availability ||= @response.data.find('//domain:name', namespaces).inject({}) do |hash, node|
            hash[node.content.strip] = node['avail'] == '1'
            hash
          end
        end
    end
  end
end
