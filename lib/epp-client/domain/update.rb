require File.expand_path('../command', __FILE__)

module EPP
  module Domain
    class Update < Command
      ADD_REM_ORDER = [:ns, :contact, :status]
      CHG_ORDER     = [:registrant, :auth_info]


      # @option [Hash] :status A Hash of status value to text. Text may optionally be an array in the form ["Text", "lang"] if a custom language value needs to be set.
      def initialize(name, options = {})
        @name = name
        @add  = Hash(options.delete(:add))
        @rem  = Hash(options.delete(:rem))
        @chg  = Hash(options.delete(:chg))

        @add.delete_if { |k,_| !ADD_REM_ORDER.include?(k) }
        @rem.delete_if { |k,_| !ADD_REM_ORDER.include?(k) }
        @chg.delete_if { |k,_| !CHG_ORDER.include?(k) }
      end

      def name
        'update'
      end

      def to_xml
        node = super
        node << domain_node('name', @name)

        unless @add.empty?
          node << add = domain_node('add')
          add_rem_to_xml(add, @add)
        end

        unless @rem.empty?
          node << rem = domain_node('rem')
          add_rem_to_xml(rem, @rem)
        end

        unless @chg.empty?
          node << chg = domain_node('chg')
          CHG_ORDER.each do |key|
            value = @chg[key]
            next if value.nil?
            
            case key
            when :registrant
              chg << domain_node('registrant', value)
            when :auth_info
              chg << auth_info_to_xml(value)
            end
          end
        end
        
        node
      end

      protected
        def add_rem_to_xml(node, hash)
          ADD_REM_ORDER.each do |key|
            value = hash[key]
            next if value.nil? || value.empty?

            case key
            when :ns
              node << nameservers_to_xml(value)
            when :contact
              contacts_to_xml(node, value)
            when :status
              value.each do |status, text|
                text, lang = Array(text)
                node << s = domain_node('status', text)
                s['lang'] = lang if lang
                s['s'] = status.to_s
              end
            end
          end
        end
    end
  end
end
