require 'helper'

class TestEppDomainCreateResponse < Test::Unit::TestCase
  context 'EPP::Domain::CreateResponse' do
    setup do
      @response = EPP::Response.new(load_xml('domain/create'))
      @create_response = EPP::Domain::CreateResponse.new(@response)
    end

    should 'proxy methods to @response' do
      assert_equal @response.message, @create_response.message
    end

    should 'be successful' do
      assert @create_response.success?
      assert_equal 1000, @create_response.code
    end

    should 'have message' do
      assert_equal 'Command completed successfully', @create_response.message
    end

    should 'have name example.com' do
      assert_equal 'example.com', @create_response.name
    end

    should 'have new creation date' do
      # 1999-04-03T22:00:00.0Z
      expected = Time.gm(1999,04,03,22,00,00)
      assert_equal expected, @create_response.creation_date
    end

    should 'have new expiration date' do
      # 2001-04-03T22:00:00.0Z
      expected = Time.gm(2001,04,03,22,00,00)
      assert_equal expected, @create_response.expiration_date
    end
  end
end
