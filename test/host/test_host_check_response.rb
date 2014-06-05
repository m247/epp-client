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

    should 'have names' do
      expected = ['ns1.example.com', 'ns2.example2.com', 'ns3.example3.com'].sort
      assert_equal expected, @check_response.names.sort
    end

    should 'have count' do
      assert_equal 3, @check_response.count
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

  context 'EPP::Host::CheckResponse Single Query' do
    setup do
      @response = EPP::Response.new(load_xml('host/check-single'))
      @check_response = EPP::Host::CheckResponse.new(@response)
    end

    should 'have names' do
      assert_equal ['ns1.example.com'], @check_response.names
    end

    should 'have name' do
      assert_equal 'ns1.example.com', @check_response.name
    end

    should 'have count' do
      assert_equal 1, @check_response.count
    end

    should 'list ns1.example.com as available' do
      assert @check_response.available?('ns1.example.com')
      assert !@check_response.unavailable?('ns1.example.com')
    end

    should 'be available? with no argument' do
      assert @check_response.available?
      assert !@check_response.unavailable?
    end
  end
end
