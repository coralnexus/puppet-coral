#
# coral_include.rb
#
# This function includes classes based on dynamic configurations.
# following this order
# - Hiera backend, if present (no prefix)
# - ::data::default::varname
# - ::varname
# - {default parameter}
#
module Puppet::Parser::Functions
  newfunction(:coral_include, :doc => <<-EOS
This function performs a lookup for a variable value in various locations following this order:
- Hiera backend, if present (no prefix)
- ::data::default::varname
- ::varname
- {default parameter}
If no value is found in the defined sources, it does not include any classes.
    EOS
) do |args|
    Coral.backtrace do
      raise(Puppet::ParseError, "coral_include(): Define at least the variable name " +
        "given (#{args.size} for 1)") if args.size < 1

      var_name = args[0]
      classes  = function_global_array([ var_name, [], args[1] ])
    
      if ! classes.empty?
        function_hiera_include([ classes ])
      end
    end
  end
end
