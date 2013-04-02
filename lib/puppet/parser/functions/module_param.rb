#
# module_param.rb
#
# This function performs a lookup for a variable value in various locations
# following this order
# - Hiera backend, if present (modulename prefix)
# - ::data::default::{modulename}::{varname}
# - {default parameter}
#
# Inspired by example42 -> params_lookup.rb
#
module Puppet::Parser::Functions
  newfunction(:module_param, :type => :rvalue, :doc => <<-EOS
This function performs a lookup for a variable value in various locations following this order:
- Hiera backend, if present (modulename prefix)
- ::data::default::{modulename}_{varname}
- {default parameter}
If no value is found in the defined sources, it returns an empty string ('')
    EOS
) do |args|

    raise(Puppet::ParseError, "module_param(): Define at least the variable name " +
      "given (#{args.size} for 1)") if args.size < 1
      
    Puppet.send(:debug, "module_param")
      
    #Puppet::Parser::Functions.autoloader.loadall

    value          = ''
    var_name       = args[0]
    default_value  = ( args[1] ? args[1] : '' )
    context        = ( args[2] ? args[2] : '' )
    
    module_name    = parent_module_name
    hiera_property = "#{module_name}::#{var_name}"
    
    if function_config_initialized([])
      case context
      when 'array'
        value = function_hiera_array([ hiera_property, '' ])
      when 'hash'
        value = function_hiera_hash([ hiera_property, '' ])
      else
        value = function_hiera([ hiera_property, '' ])
      end
    end
    
    
    
    value = lookupvar("::data::default::#{hiera_property}") if (value == :undefined || value == '')
    value = default_value if ( value == :undefined || value == '' )
    return value
  end
end
