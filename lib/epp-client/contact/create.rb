require File.expand_path('../command', __FILE__)

module EPP
  module Contact
    class Create < Command
      def initialize(id, options = {})
        @id = id

        @postal_info  = options.delete(:postal_info)
        @voice        = options.delete(:voice)
        @fax          = options.delete(:fax)
        @email        = options.delete(:email)
        @auth_info    = options.delete(:auth_info)
        @disclose     = options.delete(:disclose)
      end

      def name
        'create'
      end

      def to_xml
        node = super
        node << contact_node('id', @id)
        node << postal_info_to_xml(@postal_info)
        node << contact_node('voice', @voice) if @voice
        node << contact_node('fax', @fax) if @fax
        node << contact_node('email', @email)
        node << auth_info_to_xml(@auth_info)
        node << disclose_to_xml(@disclose) if @disclose
        node
      end
    end
  end
end
