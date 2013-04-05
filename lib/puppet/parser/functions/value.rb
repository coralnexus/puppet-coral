#
# value.rb
#
# Returns the internal form of a given value.
#
module Puppet::Parser::Functions
  newfunction(:value, :type => :rvalue, :doc => <<-EOS
This function returns the internal form of a given value.
    EOS
) do |args|

    raise(Puppet::ParseError, "value(): Must have a source value specified; " +
      "given (#{args.size} for 1)") if args.size < 1
      
    value       = args[0]
    undef_empty = ( args[1] ? args[1] : true)
    
    return Coral::Data.value(value, undef_empty)
  end
end
