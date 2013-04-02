#
# interpolate.rb
#
# Interpolate values from one hash to another for configuration injection.
#
module Puppet::Parser::Functions
  newfunction(:interpolate, :type => :rvalue, :doc => <<-EOS
This function interpolates values from one hash to another for configuration injections.
    EOS
) do |args|

    raise(Puppet::ParseError, "interpolate(): Define at least a property name with optional source configurations " +
      "given (#{args.size} for 2)") if args.size < 1
      
    value   = args[0]
    config  = ( args[1] ? args[1] : {} )
    pattern = ( args[2] ? args[2] : '\\$\\{?([a-zA-Z0-9\\_\\-]+)\\}?' )
    flags   = ( args[3] ? args[3] : '' )
    
    begin
      regexp = Regexp.compile(pattern, flags.split(''))
    rescue RegexpError, TypeError
    end
    
    if config.is_a?(Hash) && value.match(regexp)
      config.each do |name, data|
        if data.is_a?(Hash)
          value = function_interpolate([ config[name], config ])
          
        elsif data.is_a?(String)
          while (variable = data.match(regexp))
            if config.search(variable.captures[0])
              data = function_interpolate([ data, config ])
            end
          end
          value = value.gsub(pattern, data)
        end
      end
    end

    return value
  end
end

class Hash
  def search(search_key)
    found = false    
    self.each do |key, value|
      if key == search_key
        found = true        
      elsif value.is_a?(Hash)
        found = value.search(search_key)
      end
      break if found
    end
    return found
  end
end
