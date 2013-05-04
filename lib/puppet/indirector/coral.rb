
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
    return Coral::Config.lookup(request.key, nil, request.options[:variables])
  end
end
