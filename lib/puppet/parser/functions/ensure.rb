#
# ensure.rb
#
# Checks a given test and returns the success value or a failure value based on test results.
#
module Puppet::Parser::Functions
  newfunction(:ensure, :type => :rvalue, :doc => <<-EOS
This function checks a given test and returns the success value or a failure value based on test results.
    EOS
) do |args|
    value = nil
    Coral.backtrace do
      raise(Puppet::ParseError, "ensure(): Must have at least a test and optional success and failure values specified; " +
        "given (#{args.size} for 1)") if args.size < 1
      
      test          = args[0]
      success_value = (args.size > 1 ? args[1] : test)
      failure_value = (args.size > 2 ? args[2] : '')
      
      if Coral::Data.undef?(test) || (test.respond_to?('empty?') && test.empty?)
        value = failure_value
      else
        value = success_value
      end
    end
    return value
  end
end
