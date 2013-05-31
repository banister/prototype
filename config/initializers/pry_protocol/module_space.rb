class PryProtocol
  class ModuleSpace
    attr_accessor :o
    attr_accessor :ws

    def initialize(o, ws)
      @o = o
      @ws = ws
    end

    def process_request
      EM.defer do

        json = nil
        json = module_hash_for(o["value"])

        EM.next_tick do
          ws.send JSON.dump({ "value" => json,
                              "type" => "moduleSpace",
                              "id" => o["id"]
                            })
        end
      end
    end

    private

    def module_hash_for(mod_string)
      mod = eval(mod_string)
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
  end
end
