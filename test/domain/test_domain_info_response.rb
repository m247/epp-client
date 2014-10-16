require 'helper'

class TestEppDomainInfoResponse < Test::Unit::TestCase
  context 'EPP::Domain::InfoResponse' do
    setup do
      @response = EPP::Response.new(load_xml('domain/info'))
      @info_response = EPP::Domain::InfoResponse.new(@response)
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
      assert_equal 'example.com', @info_response.name
    end

    should 'have roid' do
      assert_equal 'EXAMPLE1-REP', @info_response.roid
    end

    should 'have status' do
      assert_equal ['ok', 'clientTransferProhibited'], @info_response.status
    end

    should 'have registrant' do
      assert_equal 'jd1234', @info_response.registrant
    end

    should 'have contacts' do
      expected = { 'admin' => 'sh8013', 'tech' => 'sh8013' }
      assert_equal expected, @info_response.contacts
    end

    should 'have nameservers' do
      expected = [ {'name' => 'ns1.example.com'},
                   {'name' => 'ns1.example.net'} ]
      assert_equal expected, @info_response.nameservers
    end

    should 'have hosts' do
      expected = %w(ns1.example.com ns2.example.com)
      assert_equal expected, @info_response.hosts
    end

    should 'have client_id' do
      assert_equal 'ClientX', @info_response.client_id
    end

    should 'have creator_id' do
      assert_equal 'ClientY', @info_response.creator_id
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

    should 'have expiration_date' do
      # 2005-04-03T22:00:00.0Z
      expected = Time.gm(2005,4,3,22,00,00)
      assert_equal expected, @info_response.expiration_date
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

    context 'no expiration_date' do
      setup do
        @response = EPP::Response.new(load_xml('domain/info-no-exDate'))
        @info_response = EPP::Domain::InfoResponse.new(@response)
      end

      should 'have nil for expiration_date' do
        assert_nil @info_response.expiration_date
      end
    end

    context 'nameserver data specified inside <hostAttr>' do
      context 'with name, ipv4 and ipv6' do
        setup do
          @response = EPP::Response.new(load_xml('domain/info-ns-hostAttr'))
          @info_response = EPP::Domain::InfoResponse.new(@response)
        end

        should 'have nameservers' do
          expected = [
                       {
                         'name' => 'ns1.example.com',
                         'ipv4' => '192.0.2.1',
                         'ipv6' => '2002:0:0:0:0:0:C000:201'
                       },
                       {
                         'name' => 'ns2.example.com',
                         'ipv4' => '192.0.2.2',
                         'ipv6' => '1080:0:0:0:8:800:200C:417A'
                       }
                     ]
          assert_equal expected, @info_response.nameservers
        end
      end

      context 'with name only' do
        setup do
          @response = EPP::Response.new(load_xml('domain/info-ns-hostAttr-name-only'))
          @info_response = EPP::Domain::InfoResponse.new(@response)
        end

        should 'have nameservers' do
          expected = [ { 'name' => 'ns1.example.com' },
                       { 'name' => 'ns2.example.com' }
                     ]
          assert_equal expected, @info_response.nameservers
        end
      end
    end
  end
end
