module EPP
  # Handles sending and receiving data to older EPP servers.
  #
  # These servers transmit the payload with CRLF at the end
  # and recieve one byte at a time until EOF is reached.
  class OldServer < Server
    # Sends frame using old method
    #
    # @param [String] xml XML payload to send
    def send_frame(xml)
      @sock.write(xml + "\r\n")
    end

    # Receives frame using old method
    #
    # @return [String] XML Payload response
    def recv_frame
      data = ''
      until @sock.eof?
        data << @sock.read(1)
      end
      data
    end
  end
end
