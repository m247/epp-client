require 'helper'

class TestEppDomainUpdateResponse < Test::Unit::TestCase
  context 'EPP::Domain::UpdateResponse' do
    setup do
      @response = EPP::Response.new(load_xml('domain/update'))
      @update_response = EPP::Domain::UpdateResponse.new(@response)
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
