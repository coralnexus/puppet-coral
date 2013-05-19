#
# coral_include.rb
#
# This function includes classes based on dynamic configurations.
# following this order
# - Hiera backend, if present (no prefix)
# - ::data::default::varname
# - ::varname
# - {default parameter}
#
module Puppet::Parser::Functions
  newfunction(:coral_include, :doc => <<-EOS
This function performs a lookup for a variable value in various locations following this order:
- Hiera backend, if present (no prefix)
- ::data::default::varname
- ::varname
- {default parameter}
If no value is found in the defined sources, it does not include any classes.
    EOS
) do |args|
    Puppet::Parser::Functions.autoloader.loadall
    function_coral_initialize([])
    
    Coral.run do
      raise(Puppet::ParseError, "coral_include(): Define at least the variable name " +
        "given (#{args.size} for 1)") if args.size < 1

      var_name   = args[0]
      parameters = ( args.size > 1 ? args[1] : {} )
      options    = ( args.size > 2 ? args[2] : {} ) 
      class_data = {}
      
      if var_name.is_a?(Array)
        # Protect against array inside array
        var_name = var_name.flatten
      else
        var_name = [ var_name ]
      end
      
      var_name.each do |name|
        classes = function_global_array([ name, [], options ])
        if classes.is_a?(Array)
          classes.each do |klass|
            class_data[klass] = parameters
          end
        end  
      end
      
      # The below is basically ripped from the include function because we
      # want to be able to pass parameters to dynamically defined classes,
      # such as the require meta-parameter so that we can more effectively
      # contain catalog resources.

      # The 'false' disables lazy evaluation.
      klasses = compiler.evaluate_classes(class_data, self, false)

      missing = class_data.keys.find_all do |klass|
        ! klasses.include?(klass)
      end

      unless missing.empty?
        # Throw an error if we didn't evaluate all of the classes.
        str = "Could not find class"
        str += "es" if missing.length > 1

        str += " " + missing.join(", ")

        if n = namespaces and ! n.empty? and n != [""]
          str += " in namespaces #{@namespaces.join(", ")}"
        end
        self.fail Puppet::ParseError, str
      end      
    end
  end
end
