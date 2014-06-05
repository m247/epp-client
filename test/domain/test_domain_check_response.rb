require 'helper'

class TestEppDomainCheckResponse < Test::Unit::TestCase
  context 'EPP::Domain::CheckResponse' do
    setup do
      @response = EPP::Response.new(load_xml('domain/check'))
      @check_response = EPP::Domain::CheckResponse.new(@response)
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

    should 'have names' do
      expected = ['example.com', 'example.net', 'example.org'].sort
      assert_equal expected, @check_response.names.sort
    end

    should 'have count' do
      assert_equal 3, @check_response.count
    end

    should 'list example.com as available' do
      assert @check_response.available?('example.com')
      assert !@check_response.unavailable?('example.com')
    end

    should 'list example.net as unavailable' do
      assert @check_response.unavailable?('example.net')
      assert !@check_response.available?('example.net')
    end

    should 'list example.org as available' do
      assert @check_response.available?('example.org')
      assert !@check_response.unavailable?('example.org')
    end

    should 'raise ArgumentError if available with no argument for count > 1' do
      assert_raise ArgumentError do
        @check_response.available?
      end
    end

    should 'raise RuntimeError if name called with count > 1' do
      assert_raise RuntimeError do
        @check_response.name
      end
    end
  end

  context 'EPP::Domain::CheckResponse Single Query' do
    setup do
      @response = EPP::Response.new(load_xml('domain/check-single'))
      @check_response = EPP::Domain::CheckResponse.new(@response)
    end

    should 'have names' do
      assert_equal ['example.com'], @check_response.names
    end

    should 'have name' do
      assert_equal 'example.com', @check_response.name
    end

    should 'have count' do
      assert_equal 1, @check_response.count
    end

    should 'list example.com as available' do
      assert @check_response.available?('example.com')
      assert !@check_response.unavailable?('example.com')
    end

    should 'be available? with no argument' do
      assert @check_response.available?
      assert !@check_response.unavailable?
    end
  end
end
