def module_hash_for(mod)
  k = mod.constants(false).each_with_object({}) do |c, h|
    if (o = mod.const_get(c)).is_a?(Module) then
      begin
        h[c] = o.constants(false).any? { |c| o.const_get(c).is_a? Module }
      rescue Pry::RescuableException
        next
      end
    end
  end

  k
end

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

      Pry.rescue do
        o = JSON.load(msg)
        json = module_hash_for(Object)
        puts JSON.dump(json)
        case o["type"]
        when "module_space"

          ws.send JSON.dump({ "value" => json,
                              "type" => "module_space"
                            })
        end
      end
    end

    ws.onclose do
      @channel.unsubscribe @subscriptions[ws.signature]
      @subscriptions.delete ws.signature
    end
  end
end
