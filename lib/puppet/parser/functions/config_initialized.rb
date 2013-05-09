#
# config_initialized.rb
#
# This function checks if Hiera is fully configured and ready to query.
#
module Puppet::Parser::Functions
  newfunction(:config_initialized, :type => :rvalue, :doc => <<-EOS
This function checks if Hiera is fully configured and ready to query.
    EOS
) do |args|
    Puppet::Parser::Functions.autoloader.loadall
    function_coral_initialize([])
    
    value = nil
    Coral.run do
      options = ( args[0] ? args[0] : {} )
    
      config = Coral::Config.new(options, {
        :scope     => self,
        :init_fact => 'hiera_ready' 
      })  
      value = Coral::Config.initialized?(config)
    end
    return value
  end
end
