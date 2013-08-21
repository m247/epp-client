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
  end
end
