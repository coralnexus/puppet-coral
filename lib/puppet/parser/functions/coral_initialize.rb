#
# coral_initialize.rb
#
# This function loads all of the Coral Ruby library files and, if requested,
# loads the included hiera_backend library overrides that provide more granular
# processing and translation of string data coming in from Hiera.
#
module Puppet::Parser::Functions
  newfunction(:coral_initialize, :doc => <<-EOS
This function loads all of the Coral Ruby library files and, if requested,
 loads the included hiera_backend library overrides that provide more granular
 processing and translation of string data coming in from Hiera.
    EOS
) do |args|
        
    unless defined?(Coral)
      use_gem = false
      
      if use_gem
        begin
          require 'coral_core'
       
        rescue LoadError
          use_gem = false
        end
      end
      
      unless use_gem
        require File.join(File.dirname(__FILE__), '..', '..', '..', 'coral', 'core', 'lib', 'coral_core.rb')  
      end
    end    
  end
end
