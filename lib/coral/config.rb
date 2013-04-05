
module Coral
module Config
    
  def self.initialized?(options = {})
    config = Config.ensure(options)
    begin
      require 'hiera_puppet'
      
      scope       = config.get(:scope, {})
      
      sep         = config.get(:sep, '::')
      prefix      = config.get(:prefix, true)    
      prefix_text = prefix ? sep : ''
      
      init_fact   = config.get(:init_fact, 'hiera_ready') 
      
      if Puppet::Parser::Functions.function('hiera')
        if scope.respond_to?('lookupvar')
          return true if scope.lookupvar("#{prefix_text}#{init_fact}") == 'true'
        else
          return true
        end
      end
    
    rescue Exception # Prevent abortions.
    end    
    return false
  end
  
  #-----------------------------------------------------------------------------
  # Instance generator
  
  def self.ensure(config)
    case config
    when Coral::Config
      return config
    when Hash
      return Config.new(config) 
    end
    return Config.new
  end
  
  #-----------------------------------------------------------------------------
  # Configuration instance
  
  def initialize(data = {}, defaults = {}, force = true)
    @force = force
    
    if defaults.is_a?(Hash) && ! defaults.empty?
      symbolized = {}
      defaults.each do |key, value|
        symbolized[key.to_sym] = value
      end
      defaults = symbolized
    end
    
    case data
    when Coral::Config
      @options = Data.merge([ defaults, data.options ], force)
    when Hash
      @options = {}
      if data.is_a?(Hash)
        symbolized = {}
        data.each do |key, value|
          symbolized[key.to_sym] = value
        end
        @options = Data.merge([ defaults, symbolized ], force)
      end  
    end
  end
  
  #---
  
  def import(data, options = {})
    config = Config.new(options, { :force => @force }).set(:context, :hash)
    
    case data
    when Hash
      symbolized = {}
      data.each do |key, value|
        symbolized[key.to_sym] = value
      end
      @options = Data.merge([ @options, symbolized ], config)
    
    when String      
      data   = Data.lookup(data, {}, config)
      Data.merge([ @options, data ], config)
     
    when Array
      data.each do |item|
        import(item, config)
      end
    end
    
    return self
  end
  
  #---
  
  def set(name, value)
    @options[name.to_sym] = value
    return self
  end
  
  def []=(name, value)
    set(name, value)
  end
  
  #---
    
  def get(name, default = nil)
    name = name.to_sym
    return @options[name] if @options.has_key?(name)
    return default
  end
  
  def [](name, default = nil)
    get(name, default)
  end
end
end