
module Coral
module Resource
  
  def self.normalize(type_name, resources, options)
    config    = Config.ensure(options)
    resources = Data.value(resources)
    
    unless resources.nil? || resources.empty?
      resources.keys.each do |name|
        if ! resources[name] || resources[name].empty? || ! resources[name].is_a?(Hash)        
          resources.delete(name)
        else
          normalize = true
          
          namevar = namevar(type_name, name)
          if resources[name].has_key?(namevar)
            value = resources[name][namevar]
            unless value.nil? || value.empty?
              resources.delete(name)
              normalize = false
            end  
          end
          
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
    
    prefix = config.get(:resource_prefix, '')
    
    resources.each do |name, data|
      resources[name]['before']    = translate_resource_refs(type_name, data['before'], config) if data.has_key?('before')
      resources[name]['notify']    = translate_resource_refs(type_name, data['notify'], config) if data.has_key?('notify')
      resources[name]['require']   = translate_resource_refs(type_name, data['require'], config) if data.has_key?('require')       
      resources[name]['subscribe'] = translate_resource_refs(type_name, data['subscribe'], config) if data.has_key?('subscribe')
      
      unless prefix.empty?
        resources["#{prefix}-#{name}"] = resources[name]
        resources.delete(name)
      end
    end
    return resources
  end
  
  #---
  
  def self.translate_resource_refs(type_name, resource_refs, options = {})
    return :undef if resource_refs.nil? || resource_refs.empty?
    
    config  = Config.ensure(options)
    prefix  = config.get(:title_prefix, '')
    
    pattern = config.get(:title_pattern, '^\s*([^\[\]]+)\s*$')
    group   = config.get(:title_var_group, 1)
    flags   = config.get(:title_flags, '')
    
    if pattern.is_a?(String)
      pattern = Regexp.escape(pattern)
    end
    regexp = Regexp.new(pattern, flags.split(''))
    
    type_name = type_name.sub(/^\@?\@/, '')
    values    = []
        
    if resource_refs.is_a?(String)
      resource_refs = resource_refs.split(/\s*,\s*/)
      unless prefix.empty?
        resource_refs.collect! do |value|
          "#{prefix}-#{value}"  
        end
      end
    end
    resource_refs.each do |ref|
      if ! ref.is_a?(Puppet::Resource)
        ref = ref.match(regexp) ? Puppet::Resource.new(type_name, ref) : Puppet::Resource.new(ref)
      end       
      values << ref
    end
    return values[0] if values.length == 1
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