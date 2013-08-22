module EPP
  module Domain
    class Response
      include ResponseHelper

      def initialize(response)
        @response = response
      end

      def method_missing(meth, *args, &block)
        return super unless @response.respond_to?(meth)
        @response.send(meth, *args, &block)
      end

      protected
        def namespaces
          {'domain' => NAMESPACE}
        end
    end
  end
end
