
module Coral
module Template
class PuppetConf < Base
  #-----------------------------------------------------------------------------
  # Renderers  
   
  def render(input)
    output = ''
        
    case input      
    when Hash
      input.each do |type, data|
        output << render_block(type, data)
      end
    end              
    return output     
  end
  
  #-----------------------------------------------------------------------------
    
  def render_block(type, input)
    output = ''
    if input.is_a?(Hash)       
      output << "[#{type}]\n"
 
      input.each do |name, value|
        output << "#{name} = #{value}\n"
      end
    end  
    return output  
  end   
end
end
end