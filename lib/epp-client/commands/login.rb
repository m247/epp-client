require File.expand_path('../command', __FILE__)

module EPP
  module Commands
    class Login < Command
      def initialize(tag, passwd, config)
        @tag, @passwd, @config = tag, passwd, config
      end

      def name
        'login'
      end

      def to_xml
        node = super
        node << epp_node('clID', @tag, @namespaces || {})
        node << epp_node('pw', @passwd, @namespaces || {})

        options  = epp_node('options', @namespaces || {})
        options << epp_node('version', @config[:version], @namespaces || {})
        options << epp_node('lang', @config[:lang], @namespaces || {})
        node << options

        svcs = epp_node('svcs', @namespaces || {})
        @config[:services].each { |uri| svcs << epp_node('objURI', uri, @namespaces || {}) }
        node << svcs

        unless @config[:extensions].empty?
          ext = epp_node('svcExtension', @namespaces || {})
          @config[:extensions].each do |uri|
            ext << epp_node('extURI', uri, @namespaces || {})
          end
          svcs << ext
        end

        node
      end
    end
  end
end
