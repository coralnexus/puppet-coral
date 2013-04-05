#
# global_param.rb
#
# This function performs a lookup for a variable value in various locations
# following this order
# - Hiera backend, if present (no prefix)
# - ::coral::default::varname
# - ::varname
# - {default parameter}
#
module Puppet::Parser::Functions
  newfunction(:global_param, :type => :rvalue, :doc => <<-EOS
This function performs a lookup for a variable value in various locations following this order:
- Hiera backend, if present (no prefix)
- ::coral::default::varname
- ::varname
- {default parameter}
If no value is found in the defined sources, it returns an empty string ('')
    EOS
) do |args|

    raise(Puppet::ParseError, "global_param(): Define at least the variable name " +
      "given (#{args.size} for 1)") if args.size < 1

    var_name      = args[0]
    default_value = ( args[1] ? args[1] : '' )
    options       = ( args[2] ? args[2] : {} )
    
    config = Coral::Config.new(options, {
      :scope     => self,
      :search    => 'coral::default',
      :init_fact => 'hiera_ready'
    })    
    return Coral::Data.lookup(var_name, default_value, config)
  end
end
