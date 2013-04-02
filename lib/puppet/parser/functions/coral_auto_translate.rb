#
# coral_auto_translate.rb
#
# This function loads the included hiera_backend library overrides that
# provide more granular processing and translation of string data coming in
# from Hiera.
#
module Puppet::Parser::Functions
  newfunction(:coral_auto_translate, :doc => <<-EOS
This function loads the included hiera_backend library overrides that
 provide more granular processing and translation of string data coming in
 from Hiera.
    EOS
) do |args|
    require File.join(File.dirname(__FILE__), '..', '..', '..', 'hiera_backend')
  end
end
