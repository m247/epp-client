require 'helper'

class TestEppContactInfoResponse < Test::Unit::TestCase
  context 'EPP::Contact::InfoResponse' do
    setup do
      @response = EPP::Response.new(load_xml('contact/info'))
      @info_response = EPP::Contact::InfoResponse.new(@response)
    end

    should 'proxy methods to @response' do
      assert_equal @response.message, @info_response.message
    end

    should 'be successful' do
      assert @info_response.success?
      assert_equal 1000, @info_response.code
    end

    should 'have message' do
      assert_equal 'Command completed successfully', @info_response.message
    end

    should 'have id' do
      assert_equal 'sh8013', @info_response.id
    end

    should 'have roid' do
      assert_equal 'SH8013-REP', @info_response.roid
    end

    should 'have status' do
      expected = %w(linked clientDeleteProhibited)
      assert_equal expected, @info_response.status
    end

    should 'have postal_info' do
      expected = { :name => "John Doe",
        :org  => "Example Inc.",
        :addr => {
          :street => "123 Example Dr.\nSuite 100",
          :city => "Dulles",
          :sp => "VA",
          :pc => "20166-6503",
          :cc => "US" }}
      assert_equal expected, @info_response.postal_info
    end

    should 'have email' do
      assert_equal 'jdoe@example.com', @info_response.email
    end

    should 'have voice' do
      assert_equal '+1.7035555555.1234', @info_response.voice
    end

    should 'have fax' do
      assert_equal '+1.7035555556', @info_response.fax
    end

    should 'have client_id' do
      assert_equal 'ClientY', @info_response.client_id
    end

    should 'have creator_id' do
      assert_equal 'ClientX', @info_response.creator_id
    end

    should 'have created_date' do
      # 1999-04-03T22:00:00.0Z
      expected = Time.gm(1999,4,3,22,00,00)
      assert_equal expected, @info_response.created_date
    end

    should 'have updator_id' do
      assert_equal 'ClientX', @info_response.updator_id
    end

    should 'have updated_date' do
      # 1999-12-03T09:00:00.0Z
      expected = Time.gm(1999,12,3,9,00,00)
      assert_equal expected, @info_response.updated_date
    end

    should 'have transfer_date' do
      # 2000-04-08T09:00:00.0Z
      expected = Time.gm(2000,4,8,9,00,00)
      assert_equal expected, @info_response.transfer_date
    end

    should 'have authInfo' do
      expected = { 'pw' => '2fooBAR' }
      assert_equal expected, @info_response.auth_info
    end

    should 'have disclose' do
      expected = { "0" => %w(voice email) }
      assert_equal expected, @info_response.disclose
    end
  end
end
