require File.expand_path('../command', __FILE__)

module EPP
  module Contact
    class Update < Command
      ADD_REM_ORDER = [:status]
      CHG_ORDER     = [:postal_info, :voice, :fax, :email, :auth_info, :disclose]

      # @option [Hash] :status A Hash of status value to text. Text may optionally be an array in the form ["Text", "lang"] if a custom language value needs to be set.
      def initialize(id, options = {})
        @id  = id
        @add = Hash(options.delete(:add))
        @rem = Hash(options.delete(:rem))
        @chg = Hash(options.delete(:chg))

        @add.delete_if { |k,_| !ADD_REM_ORDER.include?(k) }
        @rem.delete_if { |k,_| !ADD_REM_ORDER.include?(k) }
        @chg.delete_if { |k,_| !CHG_ORDER.include?(k) }
      end

      def name
        'update'
      end

      def to_xml
        node = super
        node << contact_node('id', @id)

        unless @add.empty?
          node << add = contact_node('add')
          add_rem_to_xml(add, @add)
        end

        unless @rem.empty?
          node << rem = contact_node('rem')
          add_rem_to_xml(rem, @rem)
        end

        unless @chg.empty?
          node << chg = contact_node('chg')
          CHG_ORDER.each do |key|
            value = @chg[key]
            next if value.nil? || value.empty?
            
            case key
            when :postal_info
              chg << postal_info_to_xml(value)
            when :auth_info
              chg << auth_info_to_xml(value)
            when :disclose
              chg << disclose_to_xml(value)
            when :voice, :fax, :email
              chg << contact_node(key.to_s, value)
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
            when :status
              value.each do |status, text|
                text, lang = Array(text)
                node << s = contact_node('status', text)
                s['lang'] = lang if lang
                s['s'] = status.to_s
              end
            end
          end
        end
    end
  end
end
