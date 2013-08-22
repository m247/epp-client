require 'helper'

class TestEppContactCheckResponse < Test::Unit::TestCase
  context 'EPP::Contact::CheckResponse' do
    setup do
      @response = EPP::Response.new(load_xml('contact/check'))
      @check_response = EPP::Contact::CheckResponse.new(@response)
    end

    should 'proxy methods to @response' do
      assert_equal @response.message, @check_response.message
    end

    should 'be successful' do
      assert @check_response.success?
      assert_equal 1000, @check_response.code
    end

    should 'have message' do
      assert_equal 'Command completed successfully', @check_response.message
    end

    should 'list sh8013 as available' do
      assert @check_response.available?('sh8013')
      assert !@check_response.unavailable?('sh8013')
    end

    should 'list sah8013 as unavailable' do
      assert @check_response.unavailable?('sah8013')
      assert !@check_response.available?('sah8013')
    end

    should 'list 8013sah as available' do
      assert @check_response.available?('8013sah')
      assert !@check_response.unavailable?('8013sah')
    end
  end
end
