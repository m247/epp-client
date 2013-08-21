require File.expand_path('../abstract', __FILE__)

module EPP
  module Requests
    class Command < Abstract
      def initialize(tid, command, extension = nil)
        @tid, @command, @extension = tid, command, extension
      end

      def name
        'command'
      end

      def to_xml
        node = super

        @command.set_namespaces(@namespaces) if @command.respond_to?(:set_namespaces)
        @extension.set_namespaces(@namespaces) if @extension && @extension.respond_to?(:set_namespaces)

        node << as_xml(@command)
        node << as_xml(@extension) if @extension
        node << epp_node('clTRID', @tid, @namespaces)

        node
      end
    end
  end
end
