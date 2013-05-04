
module Coral
  
  def self.backtrace
    begin
      yield
      
    rescue Exception => error
      Puppet.warning(error.inspect)
      Puppet.warning(Data.to_yaml(error.backtrace))
      raise
    end
  end
end