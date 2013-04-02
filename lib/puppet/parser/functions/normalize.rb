#
# normalize.rb
#
# Interpolates values from one hash to all values of another for configuration injections.
#
module Puppet::Parser::Functions
  newfunction(:normalize, :type => :rvalue, :doc => <<-EOS
This function merges and interpolates values from one hash to all values of another for configuration injections.
    EOS
) do |args|

    raise(Puppet::ParseError, "normalize(): Define at least a destination hash with optional source configurations " +
      "given (#{args.size} for 2)") if args.size < 1
      
    dest    = args[0]
    source  = ( args[1] ? args[1] : {} )
    pattern = ( args[2] ? args[2] : nil )
    
    combined = function_deep_merge([ dest, source ])
    return function_interpolate_full([ combined, combined, pattern ])
  end
end
