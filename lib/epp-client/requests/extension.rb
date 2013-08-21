require File.expand_path('../abstract', __FILE__)

module EPP
  module Requests
    class Extension < Abstract
      def initialize(extension)
        @extension = extension
      end

      def name
        'extension'
      end

      def to_xml
        node = super

        @extension.set_namespaces(@namespaces) if @extension.respond_to?(:set_namespaces)
        node << as_xml(@extension)
        node
      end
    end
  end
end
