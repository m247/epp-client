require File.expand_path('../command', __FILE__)

module EPP
  module Host
    class Update < Command
      ADD_REM_ORDER = [:addr, :status]
      CHG_ORDER     = [:name]

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
        node << host_node('name', @name)

        unless @add.empty?
          node << add = host_node('add')
          add_rem_to_xml(add, @add)
        end

        unless @rem.empty?
          node << rem = host_node('rem')
          add_rem_to_xml(rem, @rem)
        end

        unless @chg.empty?
          node << chg = host_node('chg')
          CHG_ORDER.each do |key|
            value = @chg[key]
            next if value.nil?
            
            case key
            when :name
              chg << host_node('name', value)
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
            when :addr
              addrs_to_xml(node, value)
            when :status
              value.each do |status, text|
                text, lang = Array(text)
                node << s = host_node('status', text)
                s['lang'] = lang if lang
                s['s'] = status.to_s
              end
            end
          end
        end
    end
  end
end
