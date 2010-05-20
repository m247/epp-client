module EPP
  class OldServer < Server
    # override function to make it respond in old type way
    def send_frame(xml)
      @sock.write(xml + "\r\n")
    end
    def recv_frame
      data = ''
      until @sock.eof?
        data << @sock.read(1)
      end
      data
    end
  end
end
