require 'helper'

class TestEppContactUpdateCommand < Test::Unit::TestCase
  context 'EPP::Contact::Update' do
    setup do
      @contact_update = EPP::Contact::Update.new('UK-4398495',
        :add => {:status => {:ok => "Okie Dokie"}},
        :rem => {:status => {:ok => ["Okie Dokie", "en"]}},
        :chg => {
          :voice       => "+44.1234567890",
          :email       => "enoch.root@test.host",
          :postal_info => {
            :org       => "Epiphyte",
            :name      => "Enoch Root",
            :addr      => {
              :street  => "1 Test Avenue",
              :city    => "Testington",
              :sp      => "Testshire",
              :pc      => "TE57 1NG",
              :cc      => "GB" } },
          :auth_info => {:pw => '2381728348'}
        })

      @update  = EPP::Commands::Update.new(@contact_update)
      @command = EPP::Requests::Command.new('ABC-123', @update)
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

    should 'set UK-4398495 as id' do
      assert_equal 'UK-4398495', xpath_find('//contact:id')
    end
    should 'add status' do
      assert_equal "Okie Dokie", xpath_find('//contact:add/contact:status')
      assert_equal "ok", xpath_find('//contact:add/contact:status/@s')
    end

    should 'remove status' do
      assert_equal "Okie Dokie", xpath_find('//contact:rem/contact:status')
      assert_equal "en", xpath_find('//contact:rem/contact:status/@lang')
      assert_equal "ok", xpath_find('//contact:rem/contact:status/@s')
    end

    should 'set voice for change' do
      assert_equal "+44.1234567890", xpath_find('//contact:chg/contact:voice')
    end
    should 'set email for change' do
      assert_equal "enoch.root@test.host", xpath_find('//contact:chg/contact:email')
    end
    should 'set organisation for change' do
      assert_equal "Epiphyte", xpath_find('//contact:chg/contact:postalInfo[@type="loc"]/contact:org')
    end
    should 'set name for change' do
      assert_equal "Enoch Root", xpath_find('//contact:chg/contact:postalInfo[@type="loc"]/contact:name')
    end
    should 'set address for change' do
      assert_equal "1 Test Avenue", xpath_find('//contact:chg/contact:postalInfo[@type="loc"]/contact:addr/contact:street')
      assert_equal "Testington", xpath_find('//contact:chg/contact:postalInfo[@type="loc"]/contact:addr/contact:city')
      assert_equal "Testshire", xpath_find('//contact:chg/contact:postalInfo[@type="loc"]/contact:addr/contact:sp')
      assert_equal "TE57 1NG", xpath_find('//contact:chg/contact:postalInfo[@type="loc"]/contact:addr/contact:pc')
      assert_equal "GB", xpath_find('//contact:chg/contact:postalInfo[@type="loc"]/contact:addr/contact:cc')
    end

    should 'set authInfo for change' do
      assert_equal '2381728348', xpath_find('//contact:chg/contact:authInfo/contact:pw')
    end
  end
end
