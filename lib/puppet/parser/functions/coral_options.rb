#
# coral_options.rb
#
# This function sets default options for other functions.
#
module Puppet::Parser::Functions
  newfunction(:coral_options, :doc => <<-EOS
This function sets default options for other functions:
EOS
) do |args|
    Puppet::Parser::Functions.autoloader.loadall
    function_coral_initialize([])
    
    Coral.run do
      raise(Puppet::ParseError, "options(): Define a context name and at least one option name/value pair: " +
        "given (#{args.size} for 2)") if args.size < 2

      context_name = args[0]
      options      = args[1] 
      
      context_name = Coral::Util::Data.prefix(self.source.module_name, context_name) 
      Coral::Config.set_options(context_name, options)
    end
  end
end
