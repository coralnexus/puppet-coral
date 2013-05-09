#
# configuration.rb
#
# Returns the Coral configurations processed so far.
#
module Puppet::Parser::Functions
  newfunction(:configuration, :type => :rvalue, :doc => <<-EOS
This function returns the Coral configurations processed so far.
    EOS
) do |args|
    Puppet::Parser::Functions.autoloader.loadall
    function_coral_initialize([])
    
    return Coral::Config.properties
  end
end
