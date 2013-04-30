
module Coral
module Template
  
  #-----------------------------------------------------------------------------
  # General template utilities
  
  def self.instance(class_name, options = {}, defaults = {}, force = true)
    return Template::const_get(class_name).new(options, defaults, force)
  end
  
  #---
  
  def self.process(value)
    case value
    when String
      return ''         if value.nil? || value == :undef
      return 'false'    if value == false
      return 'true'     if value == true      
      return value.to_s if value.is_a?(Symbol)
      
    when Hash
      value.each do |key, item|
        value[key] = process(item)
      end
      
    when Array
      value.each_with_index do |item, index|
        value[index] = process(item)
      end
    end
    return value
  end
  
  #---
  
  def self.render(class_name, data, options = {})
    config = Config.ensure(options)
    
    #dbg(class_name, 'template engine name')
    #dbg(data, 'template data -> init')
    
    case data
    when String
      data = Data.lookup(data, {}, config)
    when Array
      data = Data.merge(data, config)
    end
    #dbg(data, 'template data -> post merge')
      
    data = Data.interpolate(data, data, config)
    #dbg(data, 'template data -> post interpolate')
    
    engine = instance(class_name, config, {}, config.get(:force, true))
    #dbg(engine, 'template engine')
    
    output = engine.render(process(data))
    #dbg(output, 'template output')
    
    return output
  end

  #-----------------------------------------------------------------------------
  # Base template
  
class Base < Config
  # All template classes should extend Base
  
  def intialize(options = {}, defaults = {}, force = true)
    super(options, defaults, force)
  end
  
  #---
  
  def render(input)
    return ''  # Implement in sub classes!! 
  end
end
end
end