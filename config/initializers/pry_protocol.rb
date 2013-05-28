class PryProtocol
  def code_info_for(code_object_name)
    puts "code object name was #{code_object_name}"
    co = Pry::CodeObject.lookup(code_object_name, Pry.new) rescue "# None found"

    {
      :code => (co.source rescue "# Not found"),
      :name => co.name
    }
  end

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
