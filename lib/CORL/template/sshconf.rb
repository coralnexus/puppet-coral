
module CORL
module Template
class Sshconf < CORL.plugin_class(:template)

  #-----------------------------------------------------------------------------
  # Renderers  
   
  def render_processed(input)
    output = ''
       
    case input      
    when Hash
      input.each do |name, value|
        if value.is_a?(Array)
          value.each do |item|
            output << "#{name} #{item}\n"  
          end
          
        elsif value.is_a?(String)
          output << "#{name} #{value}\n"
        end
      end
    end              
    return output      
  end
end
end
end