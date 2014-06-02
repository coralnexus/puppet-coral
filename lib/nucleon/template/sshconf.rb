
module Nucleon
module Template
class Sshconf < CORL.plugin_class(:nucleon, :template)

  #-----------------------------------------------------------------------------
  # Renderers  
   
  def render_processed(input)
    output = ''
    hosts  = {}
       
    case input      
    when Hash
      input.each do |name, value|
        # Only valid on client configs but similar enough in syntax that 
        # we share the template
        if name.match(/Host/i) && value.is_a?(Hash)
          # Defer rendering until the end
          hosts = value
        else
          output << render_configuration(name, value)
        end
      end
      output << "\n"
      
      hosts.each do |host, host_config|
        output << "Host #{host}\n"
        host_config.each do |name, value|
          output << render_configuration(name, value, '  ')
        end
        output << "\n"  
      end
    end              
    output      
  end
  
  #---
  
  def render_configuration(name, value, padding = '')
    output = ''
    
    if value.is_a?(Array)
      value.each do |item|
        output << render_statement(name, item, padding) 
      end          
    elsif value.is_a?(String)
      output << render_statement(name, value, padding)
    end
    output  
  end
  
  #---
  
  def render_statement(name, value, padding = '')
    "#{padding}#{name} #{value.strip}\n"
  end
end
end
end
