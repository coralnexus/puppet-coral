
module Nucleon
module Template
class Sudoersconf < CORL.plugin_class(:nucleon, :template)

  #-----------------------------------------------------------------------------
  # Renderers  
    
  def render_processed(input)
    output = defaults(input['defaults']) + "\n" +
              aliases(input['aliases']) + "\n" +
              specs(input['specs'])          
    return output      
  end
  
  #---
    
  def defaults(input)
    output = ''
    if input.is_a?(Hash)       
      input.each do |default_type, data|
        case data
        when Hash
          data.each do |parameter, value|            
            if value && ! value.empty?
              case value
              when Array
                values = []
                value.each do |item|
                  values << item
                end
                value = values.join(',')
              end
              
              equal_sign = nil            
              equal_sign = '+=' if ! equal_sign && value.match(/^\\+\\=/)
              equal_sign = '-=' if ! equal_sign && value.match(/^\\-\\=/)
              equal_sign = '=' unless equal_sign                            
              
              output << "#{default_type} #{parameter} #{equal_sign} #{value}\n"              
            else
              output << "#{default_type} #{parameter}\n"   
            end
          end
        end
      end
    end  
    return output
  end
  
  #---
    
  def aliases(input)
    output = ''
    if input.is_a?(Hash)       
      input.each do |alias_type, data|
        case data
        when Hash
          data.each do |name, value|
            if value && ! value.empty?
              case value
              when Array
                values = []
                value.each do |item|
                  values << item
                end
                value = values.join(',')
              end
              output << "#{alias_type} #{name} = #{value}\n"
            end
          end
        end
      end
    end  
    return output
  end
  
  #---
  
  def specs(input)
    output = ''
    if input.is_a?(Hash)       
      input.each do |spec_name, value|
        if value && ! value.empty?
          case value
          when Array
            value.each do |item|
              output << "#{spec_name} #{item}\n" 
            end
                
          when String
            output << "#{spec_name} #{value}\n" 
          end
        end
      end
    end  
    return output
  end 
end
end
end
