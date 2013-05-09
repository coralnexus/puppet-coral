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
    Puppet::Parser::Functions.autoloader.loadall
    function_coral_initialize([])
    
    value = nil
    Coral.run do
      raise(Puppet::ParseError, "value(): Must have a source value specified; " +
        "given (#{args.size} for 1)") if args.size < 1
      
      value = Coral::Util::Data.value(args[0])
    end
    return value
  end
end
