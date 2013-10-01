require File.expand_path('../command', __FILE__)

module EPP
  module Domain
    class Create < Command
      #
      # @param [String] name
      # @param [String] period
      # @param [Array<String,Hash>] nameservers
      # @param [String] registrant
      # @param [Hash<Symbol,String>] contacts
      # @param [Hash<Symbol,String>] auth_info
      #
      # @option contacts [String] :admin
      # @option contacts [String] :tech
      # @option contacts [String] :billing
      def initialize(name, options = {})
        @name = name
        @period = options.delete(:period) || '1y'
        @nameservers = Array(options.delete(:nameservers)) 
        @registrant = options.delete(:registrant)
        @contacts = options.delete(:contacts)
        @auth_info = options.delete(:auth_info)
      end

      def name
        'create'
      end

      def to_xml
        node = super
        node << domain_node('name', @name)
        node << period_to_xml(@period) if @period

        unless @nameservers.empty?
          node << nameservers_to_xml(@nameservers)
        end

        node << domain_node('registrant', @registrant) if @registrant

        contacts_to_xml(node, @contacts)

        node << auth_info_to_xml(@auth_info) unless @auth_info.empty?
        
        node
      end
    end
  end
end
