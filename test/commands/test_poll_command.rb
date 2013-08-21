require 'helper'

class TestEppPollCommand < Test::Unit::TestCase
  context 'EPP::Commands::Poll' do
    context 'poll' do
      setup do
        @poll    = EPP::Commands::Poll.new
        @command = EPP::Requests::Command.new('ABC-123', @poll)
        @request = EPP::Request.new(@command)
        @xml     = @request.to_xml

        namespaces_from_request
      end

      should 'validate against schema' do
        assert @xml.validate_schema(schema)
      end

      should 'set clTRID' do
        assert_equal 'ABC-123', xpath_find('//epp:clTRID')
      end

      should 'set op mode req' do
        assert_equal 'req', xpath_find('//epp:poll/@op')
      end
    end
    context 'ack' do
      setup do
        @poll    = EPP::Commands::Poll.new('234629834')
        @command = EPP::Requests::Command.new('ABC-123', @poll)
        @request = EPP::Request.new(@command)
        @xml     = @request.to_xml

        namespaces_from_request
      end

      should 'validate against schema' do
        assert @xml.validate_schema(schema)
      end

      should 'set clTRID' do
        assert_equal 'ABC-123', xpath_find('//epp:clTRID')
      end

      should 'set op mode ack' do
        assert_equal 'ack', xpath_find('//epp:poll/@op')
      end

      should 'set msgID' do
        assert_equal '234629834', xpath_find('//epp:poll/@msgID')
      end
    end
  end
end
