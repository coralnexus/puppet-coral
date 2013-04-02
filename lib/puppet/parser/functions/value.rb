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
    
    case value
    when String # It SUCKS that Puppet translates undef to ''
      if ( undef_empty && value.empty? ) || value.match(/^\s*(undef|UNDEF|Undef|nil|NIL|Nil)\s*$/)
        value = :undef
      elsif value.match(/^\s*(true|TRUE|True)\s*$/)
        value = true
      elsif value.match(/^\s*(false|FALSE|False)\s*$/)
        value = false
      end
    
    when Array
      results = []
      value.each do |data|
        results << function_value([ data ])
      end
      value = results
    
    when Hash
      value.each do |key, data|
        value[key] = function_value([ data ])
      end
    end
    return value
  end
end
