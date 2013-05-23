def module_hash_for(mod)
  k = mod.constants(false).each_with_object([]) do |c, a|
    if (o = mod.const_get(c)).is_a?(Module) then
      begin
        a << {
          :name => c,
          :fullName => o.name.to_s,
          :stub => true,
          :hasChildren => o.constants(false).any? { |c| o.const_get(c).is_a?(Module) }
        }
      rescue Pry::RescuableException
        next
      end
    end
  end

  {
    :name => mod.name,
    :stub => false,
    :hasChildren => k.any?,
    :children => k
  }
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

      o = JSON.load(msg)
      case o["type"]
      when "module_space"

        EM.defer do
          json = module_hash_for(Object)
          EM.next_tick do
            ws.send JSON.dump({ "value" => json,
                                "type" => "module_space",
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
