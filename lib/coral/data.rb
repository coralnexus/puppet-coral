
module Kernel
  def dbg(data, label = '')
    require 'pp'
    
    puts '>>----------------------'
    unless label.empty?
      puts label
      puts '---'
    end
    pp data
    puts '<<'
  end
end

module Coral
module Data
  
  def self.value(value, undef_empty = false)
    case value
    when String # It SUCKS that Puppet translates undef to '' in functions :-(
      if undef_empty && undef?(value)
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
  
  def self.undef?(value)
    if value.nil? || 
      (value.is_a?(Symbol) && value == :undef || value == :undefined) || 
      (value.is_a?(String) && value.match(/^\s*(undef|UNDEF|Undef|nil|NIL|Nil)\s*$/))
      return true
    end
    return false  
  end
  
  #---
  
  def self.true?(value)
    if value == true || value.match(/^\s*(true|TRUE|True)\s*$/)
      return true
    end
    return false  
  end
  
  #---
  
  def self.false?(value)
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
    
    #dbg(default, "lookup -> #{name}")
    
    if Config.initialized?(options)
      unless scope.respond_to?("[]")
        scope = Hiera::Scope.new(scope)
      end
      value = hiera.lookup(name, default, scope, override, context)
      #dbg(value, "hiera -> #{name}")
    end 
    
    if undef?(value) && scope.respond_to?('lookupvar')
      log_level = Puppet::Util::Log.level
      Puppet::Util::Log.level = :err # Don't want failed parameter lookup warnings here.
      
      if base_names
        if base_names.is_a?(String)
          base_names = [ base_names ]
        end
        base_names.each do |item|
          value = scope.lookupvar("#{prefix_text}#{item}#{sep}#{name}")
          #dbg(value, "#{prefix_text}#{item}#{sep}#{name}")
          break unless undef?(value)  
        end
      end
      if undef?(value) && search_name
        value = scope.lookupvar("#{prefix_text}#{name}")
        #dbg(value, "#{prefix_text}#{name}")
      end
      Puppet::Util::Log.level = log_level
    end    
    value = default if undef?(value)
    
    #dbg(value, "result -> #{name}")    
    return value  
  end
  
  #---
  
  def self.merge(data, force = true)
    value = data
    
    # Special case because this method is called from within Config.new so we 
    # can not use Config.ensure, as that would cause an infinite loop.
    force = force.is_a?(Coral::Config) ? force.get(:force, force) : force
    
    #dbg(data, 'data')
    
    if data.is_a?(Array)
      value = data.shift
      data.each do |item|
        #dbg(item, 'item')
        case value
        when Hash
          begin
            require 'deep_merge'
            value = force ? value.deep_merge!(item) : value.deep_merge(item)
          rescue LoadError
            if item.is_a?(Hash) # Non recursive top level by default.
              value = value.merge(item)                
            elsif force
              value = item
            end
          end  
        when Array
          if item.is_a?(Array)
            value = value.concat(item).uniq
          elsif force
            value = item
          end
        end
      end  
    end
    
    #dbg(value, 'value')            
    return value
  end
  
  #---

  def self.normalize(data, override = nil, options = {})
    config  = Config.ensure(options)
    results = {}
    
    unless undef?(override)
      case data
      when String, Symbol
        data = [ data, override ] if data != override
      when Array
        data << override unless data.include?(override)
      when Hash
        data = [ data, override ]
      end
    end
    
    case data
    when String, Symbol
      results = lookup(data, {}, config)
      
    when Array
      data.each do |item|
        if item.is_a?(String)
          item = lookup(item, {}, config)
        end
        unless undef?(item)
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
  
    pattern = config.get(:pattern, '\$(\{)?([a-zA-Z0-9\_\-]+)(\})?')
    group   = config.get(:var_group, 2)
    flags   = config.get(:flags, '')
    
    if scope.is_a?(Hash)
      regexp = Regexp.new(pattern, flags.split(''))
    
      replace = lambda do |item|
        matches = item.match(regexp)
        result  = nil
        
        #dbg(item, 'item')
        #dbg(matches, 'matches')
        
        unless matches.nil?
          replacement = scope.search(matches[group], config)
          result      = item.gsub(matches[0], replacement) unless replacement.nil?
        end
        return result
      end
      
      case value
      when String
        #dbg(value, 'interpolate (string) -> init')
        while (temp = replace.call(value))
          #dbg(temp, 'interpolate (string) -> replacement')
          value = temp
        end
        
      when Hash
        #dbg(value, 'interpolate (hash) -> init')
        value.each do |key, data|
          #dbg(data, "interpolate (#{key}) -> data")
          value[key] = interpolate(data, scope, config)
        end
      end
    end
    #dbg(value, 'interpolate -> result')
    return value  
  end
end
end

#*******************************************************************************
#*******************************************************************************

class Hash
  def search(search_key, options = {})
    config = Coral::Config.ensure(options)
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
          Coral::Config.new(config).set(:recurse_level, recurse_level)
        )
      end
      break unless value.nil?
    end
    return value
  end
end
