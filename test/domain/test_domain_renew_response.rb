require 'helper'

class TestEppDomainRenewResponse < Test::Unit::TestCase
  context 'EPP::Domain::RenewResponse' do
    setup do
      @response = EPP::Response.new(load_xml('domain/renew'))
      @renew_response = EPP::Domain::RenewResponse.new(@response)
    end

    should 'proxy methods to @response' do
      assert_equal @response.message, @renew_response.message
    end

    should 'be successful' do
      assert @renew_response.success?
      assert_equal 1000, @renew_response.code
    end

    should 'have message' do
      assert_equal 'Command completed successfully', @renew_response.message
    end

    should 'have name example.com' do
      assert_equal 'example.com', @renew_response.name
    end

    should 'have new expiration date' do
      expected = Time.gm(2005,04,03,22,00,00)
      assert_equal expected, @renew_response.expiration_date
    end
  end
end
