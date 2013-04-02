
module Global
module Utility
  
  def self.resource_list(resources)
    return resolve_dependencies(resources.keys, resources)
  end
  
  #---
  
  def self.resolve_dependencies(names, resources, resource_names = [])    
    case names.class
    when Hash
      names = names.keys  
    when String
      names = [ names ]
    end    
    
    names.each do |name|
      unless resource_names.include?(name)
        data     = resources[name]        
        requires = []
        
        if data.has_key?('require')
          requires = requires + data['require']
        end
        if data.has_key?('subscribe')
          requires = requires + data['subscribe']          
        end
        requires = requires.split(/\s*,\s*/) unless requires.is_a?(Array)
        
        unless requires.empty?
          requires.each do |item|
            resource_names = resolve_dependencies(item, resources, resource_names)
          end          
        end
        resource_names << name
      end
    end
    return resource_names  
  end
  
  #---
  
  def self.prune(resources)
    unless ! resources || resources.empty? || resources == :undefined
      type_name = definition_name.sub(/^\@?\@/, '')
    
      resources.keys.each do |name|
        if ! resources[name] || resources[name].empty? || ! resources[name].is_a?(Hash)        
          resources.delete(name)
        else
          namevar = Puppet::Resource.new(type_name, name).namevar
        
          if resources[name].has_key?(namevar) && resources[name][namevar].empty?
            resources.delete(name)  
          end
        end
      end
    end
    return resources
  end
  
  #---
  
  def self.translate(resources, regexp = /\[?([^\]]+)\]?\s*$/)
    type_name = definition_name.sub(/^\@?\@/, '')       
      
    resources.each do |name, data| #TODO: Make this metaparameter lookup more dynamic?
      if data.has_key?('before')
        resources[name]['before']    = translate_resource_refs(type_name, data['before'], regexp)       
      end
      if data.has_key?('notify')
        resources[name]['notify']    = translate_resource_refs(type_name, data['notify'], regexp)
      end
      if data.has_key?('require')
        resources[name]['require']   = translate_resource_refs(type_name, data['require'], regexp)        
      end
      if data.has_key?('subscribe')
        resources[name]['subscribe'] = translate_resource_refs(type_name, data['subscribe'], regexp)       
      end
    end
    return resources
  end
  
  #---
  
  def self.translate_resource_refs(type_name, resource_ids, regexp = /\[?([^\]]+)\]?\s*$/)
    return :undef unless resource_ids && ! resource_ids.empty? && resource_ids != :undef && resource_ids != 'undef'
    
    values = []    
    if resource_ids.is_a?(String)
      resource_ids = [ resource_ids ]
    end
    resource_ids.each do |id|
      info = id.match(regexp)
      ref  = nil
      
      if info && ! info.captures[0].empty?
        title = info.captures[0]
        ref   = Puppet::Resource.new(type_name, title).ref
        values << ref if ref
      end
       
      unless ref
        raise(Puppet::ParseError, "global_resources(): 'require' metaparameter given wrong type (#{id}) for #{type_name} #{resource_ids.to_s}")
      end
    end
    return values[0] if values.length == 1
    return values
  end
end
end