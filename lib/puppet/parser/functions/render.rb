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
    Puppet::Parser::Functions.autoloader.loadall
    function_coral_initialize([])
    
    value = nil
    Coral.run do
      raise(Puppet::ParseError, "render(): Must have a template class name and an optional source value specified; " +
        "given (#{args.size} for 2)") if args.size < 1
    
      class_name = args[0]  
      data       = ( args.size > 1 ? args[1] : {} )
      options    = ( args.size > 2 ? args[2] : {} )
    
      contexts = function_option_contexts([ 'data', 'render' ])
      config   = Coral::Config.init(options, contexts, {
        :scope  => self,
        :search => 'core::default'  
      })
      value = Coral::Template.render(class_name, data, config)
    end
    return value
  end
end
