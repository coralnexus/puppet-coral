#
# module_param.rb
#
# This function performs a lookup for a variable value in various locations
# following this order
# - Hiera backend, if present (modulename prefix)
# - ::coral::default::{modulename}::{varname}
# - {default parameter}
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
      
    var_name        = args[0]
    default_value   = ( args[1] ? args[1] : '' )
    options         = ( args[2] ? args[2] : {} )
    
    module_name     = parent_module_name
    module_var_name = "#{module_name}::#{var_name}"
    
    config = Coral::Config.new(options, {
      :scope       => self,
      :init_fact   => 'hiera_ready',
      :search      => 'coral::default',
      :search_name => false
    })    
    return Coral::Data.lookup(module_var_name, default_value, config)
  end
end
