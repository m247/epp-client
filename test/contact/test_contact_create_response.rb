require 'helper'

class TestEppContactCreateResponse < Test::Unit::TestCase
  context 'EPP::Contact::CreateResponse' do
    setup do
      @response = EPP::Response.new(load_xml('contact/create'))
      @create_response = EPP::Contact::CreateResponse.new(@response)
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

    should 'have id sh8013' do
      assert_equal 'sh8013', @create_response.id
    end

    should 'have new creation date' do
      # 1999-04-03T22:00:00.0Z
      expected = Time.gm(1999,04,03,22,00,00)
      assert_equal expected, @create_response.creation_date
    end
  end
end
