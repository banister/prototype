require_relative "pry_protocol"

pry_prot = PryProtocol.new

EM.next_tick do
  @channel = EM::Channel.new
  @subscriptions = {}

  EM::WebSocket.start(:host => '0.0.0.0', :port => 3001) do |ws|
    ws.onopen do
      ws.send JSON.dump({ "value" => "web sockets are working!",
                          "type" => "result"
                        })

      subscriber_id = @channel.subscribe do |msg|
        ws.send msg
      end
    end

    ws.onmessage do |msg|

      o = JSON.load(msg)
      case o["type"]
      when  "codeModel"
        json = pry_prot.code_info_for(o["value"])
        ws.send JSON.dump({
                            "value" => json,
                            "type" => "codeModel",
                            "id" => o["id"]
                          })
      when "moduleSpace"

        EM.defer do

          json = nil
          json = pry_prot.module_hash_for(o["value"])

          EM.next_tick do
            ws.send JSON.dump({ "value" => json,
                                "type" => "moduleSpace",
                                "id" => o["id"]
                              })
          end
        end
      end

    end

    ws.onclose do
      @channel.unsubscribe @subscriptions[ws.signature]
      @subscriptions.delete ws.signature
    end
  end
end
