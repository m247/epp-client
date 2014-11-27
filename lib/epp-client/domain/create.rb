require File.expand_path('../command', __FILE__)

module EPP
  module Domain
    class Create < Command
      # Domain creation command.
      #
      # @param [String] name Name of domain to create
      # @param [Hash] options Options to use to create the domain
      # @option options [String] period Years or months period to create the domain for
      # @option options [Array<String,Hash>] Array or hash of nameservers
      # @option options [String] registrant Contact handle to use as registrant
      # @option options [Hash<Symbol,String>] contacts Hash of admin, tech, billing contacts
      # @option options [Hash<Symbol,String>] auth_info Hash of auth info
      # @return [EPP::Domain::Create]
      #
      # @example Create a domain
      #   command = EPP::Domain::Create.new('example.com',
      #     period: '1y', registrant: 'test9023742684',
      #     auth_info: { pw: 'domainpassword' },
      #     contacts: { admin: 'admin123', tech: 'admin123', billing: 'admin123' },
      #     nameservers: ['ns1.test.host', 'ns2.test.host']
      #   )
      #
      # @example Create a domain with nameserver glue
      #   command = EPP::Domain::Create.new('example.com',
      #     period: '1y', registrant: 'test9023742684',
      #     auth_info: { pw: 'domainpassword' },
      #     contacts: { admin: 'admin123', tech: 'admin123', billing: 'admin123' },
      #     nameservers: [
      #       {name: 'ns1.example.com', ipv4: '198.51.100.53'}
      #       {name: 'ns2.example.com', ipv4: '198.51.100.54'}
      #     ]
      #   )
      def initialize(name, options = {})
        @name = name
        @period = options.delete(:period) || '1y'
        @nameservers = Array(options.delete(:nameservers))
        @registrant = options.delete(:registrant)
        @contacts = options.delete(:contacts)
        @auth_info = options.delete(:auth_info)

        @period_val, @period_unit = validate_period(@period)
      end

      def name
        'create'
      end

      def to_xml
        node = super
        node << domain_node('name', @name)

        if @period_val && @period_unit
          p = domain_node('period', @period_val)
          p['unit'] = @period_unit

          node << p
        end

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
