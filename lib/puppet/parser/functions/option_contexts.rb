#
# option_contexts.rb
#
# Returns the defined global and module default option contexts for given contexts.
#
module Puppet::Parser::Functions
  newfunction(:option_contexts, :type => :rvalue, :doc => <<-EOS
This function returns the defined global and module default option contexts for given contexts.
    EOS
) do |args|
    Puppet::Parser::Functions.autoloader.loadall
    function_coral_initialize([])
    
    value = {}
    Coral.run do
      raise(Puppet::ParseError, "option_contexts(): Must have at least one context specified; " +
        "given (#{args.size} for 1)") if args.size < 1
        
      value = [ 'all', args ].flatten
      
      unless Coral::Util::Data.empty?(self.source.module_name)
        module_contexts = Coral::Util::Data.prefix(self.source.module_name, value)
        value           = [ value, module_contexts ].flatten
      end       
    end
    return value
  end
end
