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
    type_name       = definition_name.sub(/^\@?\@/, '')
    var_name        = ( args[1] ? args[1] : definition_name )
    default_values  = ( args[2] ? args[2] : {} )
    
    tag             = ( args[3] ? args[3] : '' )
    tag_var         = tag.empty? ? '' : tag.gsub(/\_/, '::')
    
    override_var    = tag_var.empty? ? nil : "#{tag_var}::#{type_name}"
    default_var     = tag_var.empty? ? nil : "#{tag_var}::#{type_name}_defaults"
        
    puts "coral_resources -> #{definition_name}"
    #puts var_name.class
    #pp var_name
    #pp default_values
    
    parse = lambda do |data, override|
      results = {}
    
      if override
        case data
        when String
          data = [ data, override ] if data != override
        when Array
          data << override unless data.include?(override)
        when Hash
          data = [ data, override ]
        end
      end
    
      case data
      when String
        results = function_global_hash([ data, {} ])
      
      when Array
        data.each do |item|
          if item.is_a?(String)
            item = function_global_hash([ item, {} ])
          end
          if ! item.empty?
            results = function_deep_merge([ results, item ])          
          end
        end
  
      when Hash
        results = data
      end
      return results
    end
    
    #---
    # Resources
    
    resources = parse.call(var_name, override_dir)
    
    #---
    # Defaults
    
    default_values = parse.call(default_values, default_var)
    
    #---
    # Resource processing
    
    resources = Coral::Resource.normalize(definition_name, resources)
    
    if resources && ! resources.empty?
      resources.each do |name, data|
        unless data.empty?
          resources[name] = function_deep_merge([ default_values, data ])
          
          unless tag.empty?
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
      
      resources = Coral::Resource.translate(definition_name, function_value([ resources ]), tag)
      
      #---
      # Resource creation
      
      function_coral_create_resources([ definition_name, resources ])
    end
    
    puts '--------'
    pp resources
  end
end