#
# interpolate_full.rb
#
# Interpolates values from one hash to all values of another for configuration injections.
#
module Puppet::Parser::Functions
  newfunction(:interpolate_full, :type => :rvalue, :doc => <<-EOS
This function interpolates values from one hash to all values of another for configuration injections.
    EOS
) do |args|

    raise(Puppet::ParseError, "interpolate_full(): Define at least a destination hash with optional source configurations " +
      "given (#{args.size} for 2)") if args.size < 1
      
    dest    = args[0]
    source  = ( args[1] ? args[1] : {} )
    pattern = ( args[2] ? args[2] : nil )
    flags   = ( args[3] ? args[3] : nil )
    
    if dest.is_a?(Hash) && source.is_a?(Hash)
      dest.each do |name, data|
        if data.is_a?(Hash)
          dest[name] = function_interpolate_full([ data, source, pattern, flags ])
          
        elsif data.is_a?(String)
          dest[name] = function_interpolate(data, source, pattern, flags)
        end
      end
    end

    return dest
  end
end
