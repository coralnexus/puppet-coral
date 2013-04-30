
module Coral
module Resource
  
  def self.normalize(type_name, resources, options)
    config    = Config.ensure(options)
    resources = Data.value(resources)
    
    #dbg(resources, 'normalize -> init')
    
    unless Data.undef?(resources) || resources.empty?
      resources.keys.each do |name|
        #dbg(name, 'normalize -> name')
        if ! resources[name] || resources[name].empty? || ! resources[name].is_a?(Hash)        
          resources.delete(name)
        else
          normalize = true
          
          namevar = namevar(type_name, name)
          if resources[name].has_key?(namevar)
            value = resources[name][namevar]
            if Data.undef?(value) || value.empty?
              #dbg(value, "delete #{name}")
              resources.delete(name)
              normalize = false
            end  
          end
          
          #dbg(resources, 'normalize -> resources')
          
          if normalize
            resources[name] = normalize_keys(resources[name])
          end
        end
      end
    end
    return resources
  end
  
  #---
  
  def self.translate(type_name, resources, options = {})
    config    = Config.ensure(options)
    resources = Data.value(resources)
    results   = {}
        
    #dbg(resources, 'resources -> translate')
    
    prefix = config.get(:resource_prefix, '')
    
    name_map = {}
    resources.keys.each do |name|
      name_map[name] = true
    end
    config[:resource_names] = name_map
    
    resources.each do |name, data|
      #dbg(name, 'name')
      #dbg(data, 'data')
      
      resource = resources[name]
      resource['before']    = translate_resource_refs(type_name, data['before'], config) if data.has_key?('before')
      resource['notify']    = translate_resource_refs(type_name, data['notify'], config) if data.has_key?('notify')
      resource['require']   = translate_resource_refs(type_name, data['require'], config) if data.has_key?('require')       
      resource['subscribe'] = translate_resource_refs(type_name, data['subscribe'], config) if data.has_key?('subscribe')
      
      unless prefix.empty?
        name = "#{prefix}_#{name}"
      end
      results[name] = resource
    end
    return results
  end
  
  #---
  
  def self.translate_resource_refs(type_name, resource_refs, options = {})
    return :undef if Data.undef?(resource_refs)
    
    config         = Config.ensure(options)
    resource_names = config.get(:resource_names, {})
    prefix         = config.get(:title_prefix, '')
    
    pattern        = config.get(:title_pattern, '^\s*([^\[\]]+)\s*$')
    group          = config.get(:title_var_group, 1)
    flags          = config.get(:title_flags, '')
    
    allow_single   = config.get(:allow_single_return, true)
    
    regexp         = Regexp.new(pattern, flags.split(''))
    
    type_name      = type_name.sub(/^\@?\@/, '')
    values         = []
        
    case resource_refs
    when String
      if resource_refs.empty?
        return :undef 
      else
        resource_refs = resource_refs.split(/\s*,\s*/)
        unless prefix.empty?
          resource_refs.collect! do |value|
            if ! value.match(regexp)
              value  
            elsif resource_names.has_key?(value)
              "#{prefix}_#{value}"
            else
              nil
            end           
          end
        end
      end
        
    when Puppet::Resource
      resource_refs = [ resource_refs ]  
    end
    
    resource_refs.each do |ref|
      #dbg(ref, 'reference -> init')
      unless ref.nil?        
        unless ref.is_a?(Puppet::Resource)
          ref_is_title = ref.match(regexp)
          if prefix.empty? && ref_is_title && ! resource_names.has_key?(ref)
            #dbg(ref, 'stripping without prefix')
            ref = nil
          end
          unless ref.nil?
            ref = ref_is_title ? Puppet::Resource.new(type_name, ref) : Puppet::Resource.new(ref)
            #dbg(ref, 'new ref')
          end
        end
        #dbg(ref, 'reference -> final')       
        values << ref unless ref.nil?
      end
    end
    return values[0] if allow_single && values.length == 1
    return values
  end
  
  #---
  
  def self.type_name(value) # Basically borrowed from Puppet (damn private methods!)
    return :main if value == :main
    return "Class" if value == "" or value.nil? or value.to_s.downcase == "component"
    return value.to_s.split("::").collect { |s| s.capitalize }.join("::")
  end
  
  #---
  
  def self.namevar(type_name, resource_name) # Basically borrowed from Puppet (damn private methods!)
    resource = Puppet::Resource.new(type_name.sub(/^\@?\@/, ''), resource_name)
    
    if resource.builtin_type? and type = resource.resource_type and type.key_attributes.length == 1
      return type.key_attributes.first.to_s
    else
      return 'name'
    end
  end
    
  #---
  
  def self.normalize_keys(hash)
    result = {}
    hash.each do |key, value|
      result[key.to_s] = value
    end
    return result
  end
end
end