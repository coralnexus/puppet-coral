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
    data    = ( args[1] ? args[1] : {} )
    options = ( args[2] ? args[2] : {} )
    
    config = Coral::Config.new(options, {
      :pattern   => '(\$\{)?([a-zA-Z0-9\_\-]+)(\})?',
      :var_group => 2 
    })
    return Coral::Data.interpolate(value, data, config)
  end
end
