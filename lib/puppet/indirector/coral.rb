
require 'puppet/indirector/terminus'

class Puppet::Indirector::Coral < Puppet::Indirector::Terminus
  
  def initialize(*args)
    unless Coral::Config.initialized?
      #raise "Coral terminus not supported without the Coral library"
    end
    super
  end
  
  #---

  def find(request)
    #dbg(request.key, 'data binding key')
        
    config = Coral::Config.init_flat({}, [ 'all', 'param', 'data_binding' ], {
      :hiera_scope  => request.options[:variables],
      :init_fact    => 'hiera_ready',
      :search       => 'core::default',
      :search_name  => false,
      :force        => true
    })    
    #dbg(config.export, 'config')
    
    value = Coral::Config.lookup(request.key, nil, config)
    #dbg(value, 'value')
    
    value
  end
end
