#
# coral_resources.rb
#
# This function adds resource definitions of a specific type to the Puppet catalog
# - Requires
# - -> Puppet resource definition name (define)
# - -> Hiera lookup name (full name)
# - Optional
# - -> default values for new resources
# If no resources are found, it returns without creating anything.
#
require File.join(File.dirname(__FILE__), '..', '..', '..', 'resource')
require 'pp'

module Puppet::Parser::Functions
  newfunction(:coral_resources, :doc => <<-EOS
This function adds resource definitions of a specific type to the Puppet catalog
- Requires
- -> Puppet resource definition name (define)
- -> Hiera lookup name (full name)
- Optional
- -> default values for new resources
If no resources are found, it returns without creating anything.
    EOS
) do |args|

    raise(Puppet::ParseError, "coral_resources(): Define at least the resource type and optional variable name " +
      "given (#{args.size} for 1)") if args.size < 1
      
    definition_name = args[0]
    var_name        = ( args[1] ? args[1] : definition_name )
    default_values  = ( args[2] ? args[2] : {} )
    tag             = ( args[3] ? args[3] : '' )
    
    puts "coral_resources -> #{definition_name}"
    #puts var_name.class
    #pp var_name
    #pp default_values
    
    resource_names  = []
    
    case var_name
    when String
      resources = function_global_hash([ var_name, {} ])
      
    when Array
      resources = {}
      var_name.each do |item|
        case item
        when String
          item = function_global_hash([ item, {} ])
        end
        if ! item.empty?
          resources = function_deep_merge([ resources, item ])          
        end
      end
    
    when Hash
      resources = var_name
    end
    
    case default_values
    when String
      default_values = function_global_hash([ default_values, {} ])
      
    when Array
      defaults = {}
      default_values.each do |item|
        case item
        when String
          item = function_global_hash([ item, {} ])
        end
        if ! item.empty?
          defaults = function_deep_merge([ defaults, item ])          
        end
      end
      default_values = defaults
    end
    
    #pp resources.keys
    
    resources = Coral::Resource.normalize(definition_name, resources)
    
    if resources && ! resources.empty?
      resources.each do |name, data|
        unless data.empty?
          resources[name] = function_deep_merge([ default_values, data ])
          
          if tag
            if ! data.has_key?('tag')
              resources[name]['tag'] = tag
            else
              resource_tags = data['tag']
              case resource_tags
              when Array
                resources[name]['tag'] << tag  
              when String
                resource_tags = resource_tags.split(/\s*,\s*/).push(tag)
                resources[name]['tag'] = resource_tags
              end
            end
          end
        end
      end
      #pp resources
      
      resources = Coral::Resource.translate(definition_name, function_value([ resources ]))
      
      function_coral_create_resources([ definition_name, resources ])
    end
    
    puts '--------'
    pp resources
  end
end