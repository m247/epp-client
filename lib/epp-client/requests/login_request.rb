module EPP
  # An EPP Login Request
  class LoginRequest < Request
    def initialize(tag, passwd, transaction_id, config = {})
      super('login', transaction_id) do |login|
        tag = tag.length > 2 ? tag : "##{tag}"
        login << xml_node('clID', tag)
        login << xml_node('pw', passwd)

        options = xml_node('options')
        options << xml_node('version', config[:version])
        options << xml_node('lang',    config[:lang])
        login << options

        svcs = xml_node('svcs')
        config[:services].each { |uri| svcs << xml_node('objURI', uri) }
        login << svcs

        unless config[:extensions].empty?
          ext = xml_node('svcExtension')
          config[:extensions].each do |uri|
            ext << xml_node('extURI', uri)
          end
          svcs << ext
        end
      end
    end
  end
end
