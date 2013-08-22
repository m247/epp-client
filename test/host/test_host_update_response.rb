require 'helper'

class TestEppHostUpdateResponse < Test::Unit::TestCase
  context 'EPP::Host::UpdateResponse' do
    setup do
      @response = EPP::Response.new(load_xml('host/update'))
      @update_response = EPP::Host::UpdateResponse.new(@response)
    end

    should 'proxy methods to @response' do
      assert_equal @response.message, @update_response.message
    end

    should 'be successful' do
      assert @update_response.success?
      assert_equal 1000, @update_response.code
    end

    should 'have message' do
      assert_equal 'Command completed successfully', @update_response.message
    end
  end
end
