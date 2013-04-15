module EPP
  # An EPP Logout Request
  class LogoutRequest < Request
    def initialize
      super('logout')
    end
  end
end
