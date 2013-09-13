require 'epp-client'

module EPP
  class Client
    # Request Preparation Methods
    def check_prepare(payload, extension = nil)
      check = EPP::Commands::Check.new(payload)
      prepare_request(check, extension)
    end

    def create_prepare(payload, extension = nil)
      create = EPP::Commands::Create.new(payload)
      prepare_request(create, extension)
    end

    def delete_prepare(payload, extension = nil)
      delete = EPP::Commands::Delete.new(payload)
      prepare_request(delete, extension)
    end

    def info_prepare(payload, extension = nil)
      info = EPP::Commands::Info.new(payload)
      prepare_request(info, extension)
    end

    def renew_prepare(payload, extension = nil)
      renew = EPP::Commands::Renew.new(payload)
      prepare_request(renew, extension)
    end

    def transfer_prepare(op, payload, extension = nil)
      transfer = EPP::Commands::Transfer.new(op, payload)
      prepare_request(transfer, extension)
    end

    def update_prepare(payload, extension = nil)
      update = EPP::Commands::Update.new(payload)
      prepare_request(update, extension)
    end

    def poll_prepare
      poll = EPP::Commands::Poll.new
      prepare_request(poll)
    end
    def ack_prepare(msgID)
      ack = EPP::Commands::Poll.new(msgID)
      prepare_request(ack)
    end

    def prepare_request(cmd, extension = nil)
      @conn.prepare_request(cmd, extension)
    end
    
    # Response Preparation Methods
    def load_response(xml_data)
      EPP::Response.new(xml_data)
    end
  end
end
