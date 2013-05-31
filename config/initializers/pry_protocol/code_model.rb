class PryProtocol
  class CodeModel
    attr_accessor :o
    attr_accessor :ws

    def initialize(o, ws)
      @o = o
      @ws = ws
    end

    def process_request
      if o["requestType"] == "update"
        puts "evalling code for codeModel!"
        value = eval_code(o["value"])
      else
        value = code_info_for(o["value"])
      end

      ws.send JSON.dump({
                          "value" => value,
                          "type" => "codeModel",
                          "id" => o["id"]
                        })
    end

    private

    def eval_code(o)
      code = o["code"]
      value = nil
      begin
        TOPLEVEL_BINDING.eval(code)
        return "success"
      rescue Exception => e
        puts "code evaling failed!"
        puts e

        return "failure"
      end
    end

    def code_info_for(code_object_name)
      co = Pry::CodeObject.lookup(code_object_name, Pry.new) rescue "# None found"

      {
        :code => (co.source rescue "# Not found"),
        :name => co.name
      }
    end
  end
end
