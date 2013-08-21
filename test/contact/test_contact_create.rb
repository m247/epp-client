require 'helper'

class TestEppContactCreateCommand < Test::Unit::TestCase
  context 'EPP::Contact::Create' do
    setup do
      @contact_create = EPP::Contact::Create.new('UK-4398495',
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
        :auth_info   => {:pw => '2381728348'})

      @create  = EPP::Commands::Create.new(@contact_create)
      @command = EPP::Requests::Command.new('ABC-123', @create)
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

    should 'set id' do
      assert_equal 'UK-4398495', xpath_find('//contact:id')
    end
    
    should 'set voice' do
      assert_equal "+44.1234567890", xpath_find('//contact:voice')
    end
    should 'set email' do
      assert_equal "enoch.root@test.host", xpath_find('//contact:email')
    end
    should 'set organisation' do
      assert_equal "Epiphyte", xpath_find('//contact:postalInfo[@type="loc"]/contact:org')
    end
    should 'set name' do
      assert_equal "Enoch Root", xpath_find('//contact:postalInfo[@type="loc"]/contact:name')
    end
    should 'set address' do
      assert_equal "1 Test Avenue", xpath_find('//contact:postalInfo[@type="loc"]/contact:addr/contact:street')
      assert_equal "Testington", xpath_find('//contact:postalInfo[@type="loc"]/contact:addr/contact:city')
      assert_equal "Testshire", xpath_find('//contact:postalInfo[@type="loc"]/contact:addr/contact:sp')
      assert_equal "TE57 1NG", xpath_find('//contact:postalInfo[@type="loc"]/contact:addr/contact:pc')
      assert_equal "GB", xpath_find('//contact:postalInfo[@type="loc"]/contact:addr/contact:cc')
    end

    should 'set authInfo' do
      assert_equal '2381728348', xpath_find('//contact:authInfo/contact:pw')
    end
  end
end
