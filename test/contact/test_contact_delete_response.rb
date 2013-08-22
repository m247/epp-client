require 'helper'

class TestEppContactDeleteResponse < Test::Unit::TestCase
  context 'EPP::Contact::DeleteResponse' do
    setup do
      @response = EPP::Response.new(load_xml('contact/delete'))
      @delete_response = EPP::Contact::DeleteResponse.new(@response)
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
