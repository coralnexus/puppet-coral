
require 'puppet/indirector/terminus'

class Puppet::Indirector::Coral < Puppet::Indirector::Terminus
  
  def initialize(*args)
    unless Coral::Config.initialized?
      raise "Coral terminus not supported without the Coral library"
    end
    super
  end
  
  #---

  def find(request)
    dbg(request.key, 'data binding key')
        
    config = Coral::Config.init({}, [ 'all', 'param', 'data_binding' ], {
      :scope       => request.options[:variables],
      :init_fact   => 'hiera_ready',
      :search      => 'core::default',
      :search_name => false,
      :force       => true
    })    
    #dbg(config, 'config')
    
    value = Coral::Config.lookup(request.key, nil, config)
    #dbg(value, 'value')
  end
end
