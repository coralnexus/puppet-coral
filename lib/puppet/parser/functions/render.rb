#
# render.rb
#
# Returns the string-ified form of a given value or set of values.
#
module Puppet::Parser::Functions
  newfunction(:render, :type => :rvalue, :doc => <<-EOS
This function returns the string-ified form of a given value.
    EOS
) do |args|

    raise(Puppet::ParseError, "render(): Must have a source value specified; " +
      "given (#{args.size} for 1)") if args.size < 1
      
    value = args.shift
    
    if ! value.is_a?(String)
      if value == true
        value = 'true'
      elsif value == false
        value = 'false'
      elsif value == :undef || value.nil?
        value = 'undef'
      end
      
      case value
      when Array
        results = []
        value.each do |data|
          results << function_render([ data ])
        end
        value = results
    
      when Hash
        value.each do |key, data|
          value[key] = function_render([ data ])
        end
      end
    end
    
    return value
  end
end
