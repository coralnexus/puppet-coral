
require 'puppet/indirector/terminus'

class Puppet::Indirector::Coral < Puppet::Indirector::Terminus
  
  def initialize(*args)
    if ! Coral::Config.initialized?
      raise "Coral terminus not supported without the Coral library"
    end
    super
  end
  
  #---

  def find(request)
    config = Coral::Config.new({
      :scope       => request.options[:variables],
      :init_fact   => 'hiera_ready',
      :search      => 'global::default',
      :search_name => false,
      :force       => true
    }) 
    return Coral::Config.lookup(request.key, nil, config)
  end
end
