require 'helper'

class TestEppHostCheckResponse < Test::Unit::TestCase
  context 'EPP::Host::CheckResponse' do
    setup do
      @response = EPP::Response.new(load_xml('host/check'))
      @check_response = EPP::Host::CheckResponse.new(@response)
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

    should 'list ns1.example.com as available' do
      assert @check_response.available?('ns1.example.com')
      assert !@check_response.unavailable?('ns1.example.com')
    end

    should 'list ns2.exampl2.com as unavailable' do
      assert @check_response.unavailable?('ns2.example2.com')
      assert !@check_response.available?('ns2.example2.com')
    end

    should 'list ns3.example3.com as available' do
      assert @check_response.available?('ns3.example3.com')
      assert !@check_response.unavailable?('ns3.example3.com')
    end
  end
end
