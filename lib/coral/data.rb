
module Coral
module Data
  
  def self.value(value, undef_empty = false)
    case value
    when String # It SUCKS that Puppet translates undef to '' in functions :-(
      if ( undef_empty && value.empty? ) || 
        value.match(/^\s*(undef|UNDEF|Undef|nil|NIL|Nil)\s*$/)
        value = nil
      elsif value.match(/^\s*(true|TRUE|True)\s*$/)
        value = true
      elsif value.match(/^\s*(false|FALSE|False)\s*$/)
        value = false
      end
    
    when Array
      value.each_with_index do |item, index|
        value[index] = value(item)
      end
    
    when Hash
      value.each do |key, data|
        value[key] = value(data)
      end
    end
    return value  
  end
  
  #---
  
  def self.is_true?(value)
    if value == true || value.match(/^\s*(true|TRUE|True)\s*$/)
      return true
    end
    return false  
  end
  
  #---
  
  def self.is_false?(value)
    if value == false || value.match(/^\s*(false|FALSE|False)\s*$/)
      return true
    end
    return false  
  end
  
  #---
  
  def self.lookup(name, default = nil, options = {})
    config = Config.ensure(options)
    value  = nil
    
    context     = config.get(:context, :priority)
    scope       = config.get(:scope, {})
    override    = config.get(:override, nil)
    
    base_names  = config.get(:search, nil)
    sep         = config.get(:sep, '::')
    prefix      = config.get(:prefix, true)    
    prefix_text = prefix ? sep : ''
    
    search_name = config.get(:search_name, true)
    
    #puts "lookup -> #{name}"
    #pp default
    
    if Config.initialized?(options)
      unless scope.respond_to?("[]")
        scope = Hiera::Scope.new(scope)
      end
      value = hiera.lookup(name, default, scope, override, context)
      #pp value
    end

    if value.nil? && scope.respond_to?('lookupvar')
      if base_names
        if base_names.is_a?(String)
          base_names = [ base_names ]
        end
        base_names.each do |item|
          value = scope.lookupvar("#{prefix_text}#{item}#{sep}#{name}")
          #pp value
          break unless value.nil?  
        end
      end
      if value.nil? && search_name
        value = scope.lookupvar("#{prefix_text}#{name}")
        #pp value
      end
    end    
    value = default if value.nil?
    
    #pp value    
    return value  
  end
  
  #---
  
  def self.merge(data, force = true)
    value = nil   
    
    # Special case because this method is called from within Config.new so we 
    # can not use Config.ensure, as that would cause an infinite loop.
    force = force.is_a?(Coral::Config) ? force.get(:force, force) : force
    
    case data
    when Hash
      value = data  
    when Array
      value = {}
      data.each do |item|
        case item
        when Hash
          begin
            require 'deep_merge'
            value = force ? value.deep_merge!(item) : value.deep_merge(item)
          rescue LoadError
            value = value.merge(item)
          end  
        when Array
          value = merge([ value, item ], force)
        end
      end
    end
            
    return value
  end
  
  #---

  def self.normalize(data, override = nil, options = {})
    config  = Config.ensure(options)
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
      results = lookup(data, {}, config)
      
    when Array
      data.each do |item|
        if item.is_a?(String)
          item = lookup(item, {}, config)
        end
        if ! item.empty?
          results = merge([ results, item ], config)
        end
      end
  
    when Hash
      results = data
    end
    
    return results
  end
  
  #---
  
  def self.interpolate(value, scope, options = {})    
    config  = Config.ensure(options)
  
    pattern = config.get(:pattern, '(\$\{)?([a-zA-Z0-9\_\-]+)(\})?')
    group   = config.get(:var_group, 2)
    flags   = config.get(:flags, '')
    
    if scope.is_a?(Hash)
      if pattern.is_a?(String)
        pattern = Regexp.escape(pattern)
      end
      regexp = Regexp.new(pattern, flags.split(''))
    
      replace = lambda do |item|
        matches = item.match(regexp)
        value   = nil
      
        unless matches.nil?
          replacement = scope.search(matches[group], config)
          value       = value.gsub(matches[0], replacement) unless replacement.nil?
        end
        return value
      end
      
      case value
      when String
        while (temp = replace.call(value))
          value = temp
        end
        
      when Hash
        results = {}
        value.each do |key, data|
          value[key] = interpolate(data, scope, config)
        end
        value = results
      end
    end
    
    return value  
  end
end
end

#*******************************************************************************
#*******************************************************************************

class Hash
  def search(search_key, options = {})
    config = Config.ensure(options)
    value  = nil
    
    recurse       = config.get(:recurse, false)
    recurse_level = config.get(:recurse_level, -1)
        
    self.each do |key, data|
      if key == search_key
        value = data
        
      elsif data.is_a?(Hash) && 
        recurse && (recurse_level == -1 || recurse_level > 0)
        
        recurse_level -= 1 unless recurse_level == -1
        value = value.search(search_key, 
          Config.new(config).set(:recurse_level, recurse_level)
        )
      end
      break unless value.nil?
    end
    return value
  end
end
