require File.expand_path('../response', __FILE__)

module EPP
  module Domain
    class CreateResponse < Response
      # Return the name of the domain created if successful
      #
      # @return [String] Name of created domain
      def name
        return nil unless success?
        @name ||= value_for_xpath('//domain:name')
      end
      # Return the creation/registration date of the domain if the request was successful.
      #
      # @return [Time] Registration time
      def creation_date
        return nil unless success?
        @crdate ||= value_for_xpath('//domain:crDate') && Time.parse(value_for_xpath('//domain:crDate'))
      end
      # Return the expiration date of the domain if the request was successful.
      #
      # @return [Time] Expiration time
      def expiration_date
        return nil unless success?
        @exdate ||= value_for_xpath('//domain:exDate') && Time.parse(value_for_xpath('//domain:exDate'))
      end
    end
  end
end
