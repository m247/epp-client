require 'helper'

class TestEppDomainDeleteResponse < Test::Unit::TestCase
  context 'EPP::Domain::DeleteResponse' do
    setup do
      @response = EPP::Response.new(load_xml('domain/delete'))
      @delete_response = EPP::Domain::DeleteResponse.new(@response)
    end

    should 'proxy methods to @response' do
      assert_equal @response.message, @delete_response.message
    end

    should 'be successful' do
      assert @delete_response.success?
      assert_equal 1000, @delete_response.code
    end

    should 'have message' do
      assert_equal 'Command completed successfully', @delete_response.message
    end
  end
end
