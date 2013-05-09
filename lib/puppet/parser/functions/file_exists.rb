#
# file_exists.rb
#
module Puppet::Parser::Functions
  newfunction(:file_exists, :type => :rvalue, :doc => <<-EOS
Returns an boolean value if a given file and/or directory exists on Puppet Master.
EOS
  ) do |args|
    Puppet::Parser::Functions.autoloader.loadall
    function_coral_initialize([])
    
    value = nil
    Coral.run do
      raise(Puppet::ParseError, "file_exists(): Must have a file or directory name specified; " +
        "given (#{args.size} for 1)") if args.size < 1
      
      value = File.exists?(File.expand_path(args[0]))
    end
    return value
  end
end