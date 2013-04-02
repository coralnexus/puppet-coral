#
# global_resources.rb
#
# This function adds resource definitions of a specific type to the Puppet catalog
# - Requires
# - -> Puppet resource definition name (define)
# - -> Hiera lookup name (full name)
# - Optional
# - -> default values for new resources
# If no resources are found, it returns without creating anything.
#
require File.join(File.dirname(__FILE__), '..', '..', '..', 'utility')

module Puppet::Parser::Functions
  newfunction(:global_resources, :type => :rvalue, :doc => <<-EOS
This function adds resource definitions of a specific type to the Puppet catalog
- Requires
- -> Puppet resource definition name (define)
- -> Hiera lookup name (full name)
- Optional
- -> default values for new resources
If no resources are found, it returns without creating anything.
    EOS
) do |args|

    raise(Puppet::ParseError, "global_resources(): Define at least the resource type and optional variable name " +
      "given (#{args.size} for 1)") if args.size < 1
      
    Puppet.send(:debug, "global_resources")

    #Puppet::Parser::Functions.autoloader.loadall
    
    definition_name = args[0]
    var_name        = ( args[1] ? args[1] : definition_name )
    default_values  = ( args[2] ? args[2] : {} )
    
    resource_names  = []
    
    case var_name.class
    when String
      #resources = function_global_hash([ var_name, default_values ])
      
    when Array
      resources = default_values
      var_name.each do |item|
        case item.class
        when String
          #resources = function_global_hash([ item, resources ])
        when Hash
          #resources = function_deep_merge([ resources, item ])
        end
      end
    
    when Hash
      resources = var_name
    end
    
    
    
    #resources = Global::Utility.prune(resources)
    
    #if resources && ! resources.empty?
    #  resources = Global::Utility.translate(resources)
      
    #  function_create_resources([ definition_name, resources ])     
    #  resource_names = Global::Utility.resource_list(resources)
    #end
    return resource_names
  end
end