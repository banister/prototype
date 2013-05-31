require_relative 'pry_protocol/code_model'
require_relative 'pry_protocol/module_space'

class PryProtocol
  attr_accessor :ws

  def process_json(msg)
    o = JSON.load(msg)
    case o["type"]
    when  "codeModel"
      CodeModel.new(o, ws).process_request
    when "moduleSpace"
      ModuleSpace.new(o, ws).process_request
    end
  end
end
