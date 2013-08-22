module EPP
  module Contact
    class Response
      def initialize(response)
        @response = response
      end
      
      def method_missing(meth, *args, &block)
        return super unless @response.respond_to?(meth)
        @response.send(meth, *args, &block)
      end

      protected
        def namespaces
          {'contact' => NAMESPACE}
        end
    end
  end
end
