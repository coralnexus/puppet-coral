#
# global_options.rb
#
# This function sets globally available default options for other functions.
#
module Puppet::Parser::Functions
  newfunction(:global_options, :doc => <<-EOS
This function sets globally available default options for other functions:
EOS
) do |args|
    Puppet::Parser::Functions.autoloader.loadall
    function_coral_initialize([])
    
    Coral.run do
      raise(Puppet::ParseError, "global_options(): Define a context name and at least one option name/value pair: " +
        "given (#{args.size} for 2)") if args.size < 2

      context_names = args[0]
      options       = args[1]
      
      unless context_names.is_a?(Array)
        context_names = [ context_names ]
      end
      
      context_names.each do |context_name|
        Coral::Config.set_options(context_name, options)
      end
    end
  end
end
