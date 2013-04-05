#
# is_true.rb
#
# Checks whether a given string or boolean value is true.
#
module Puppet::Parser::Functions
  newfunction(:is_true, :type => :rvalue, :doc => <<-EOS
This function checks whether a given value is true.
    EOS
) do |args|

    raise(Puppet::ParseError, "is_true(): Must have a value to check; " +
      "given (#{args.size} for 1)") if args.size < 1
      
    return Coral::Data.is_true?(args[0])
  end
end
