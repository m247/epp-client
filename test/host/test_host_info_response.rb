require 'helper'

class TestEppHostInfoResponse < Test::Unit::TestCase
  context 'EPP::Host::InfoResponse' do
    setup do
      @response = EPP::Response.new(load_xml('host/info'))
      @info_response = EPP::Host::InfoResponse.new(@response)
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

    should 'have name' do
      assert_equal 'ns1.example.com', @info_response.name
    end

    should 'have roid' do
      assert_equal 'NS1_EXAMPLE1-REP', @info_response.roid
    end

    should 'have status' do
      expected = %w(linked clientUpdateProhibited)
      assert_equal expected, @info_response.status
    end

    should 'have addresses' do
      expected = {'ipv4' => %w(192.0.2.2 192.0.2.29),
                  'ipv6' => %w(1080:0:0:0:8:800:200C:417A)}
      assert_equal expected, @info_response.addresses
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
  end
end
