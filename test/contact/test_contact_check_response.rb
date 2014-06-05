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

    should 'have ids' do
      expected = ['sh8013', 'sah8013', '8013sah'].sort
      assert_equal expected, @check_response.ids.sort
    end

    should 'have count' do
      assert_equal 3, @check_response.count
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

    should 'raise ArgumentError if available with no argument for count > 1' do
      assert_raise ArgumentError do
        @check_response.available?
      end
    end

    should 'raise RuntimeError if id called with count > 1' do
      assert_raise RuntimeError do
        @check_response.id
      end
    end
  end

  context 'EPP::Contact::CheckResponse Single Query' do
    setup do
      @response = EPP::Response.new(load_xml('contact/check-single'))
      @check_response = EPP::Contact::CheckResponse.new(@response)
    end

    should 'have names' do
      assert_equal ['sh8013'], @check_response.ids
    end

    should 'have name' do
      assert_equal 'sh8013', @check_response.id
    end

    should 'have count' do
      assert_equal 1, @check_response.count
    end

    should 'list sh8013 as available' do
      assert @check_response.available?('sh8013')
      assert !@check_response.unavailable?('sh8013')
    end

    should 'be available? with no argument' do
      assert @check_response.available?
      assert !@check_response.unavailable?
    end
  end
end
