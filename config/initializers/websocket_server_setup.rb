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

    ws.onclose do
      @channel.unsubscribe @subscriptions[ws.signature]
      @subscriptions.delete ws.signature
    end
  end
end
