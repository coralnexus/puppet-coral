#
# deep_merge.rb
#
# Merges multiple hashes together recursively.
#
module Puppet::Parser::Functions
  newfunction(:deep_merge, :type => :rvalue, :doc => <<-EOS
This function Merges multiple hashes together recursively.
    EOS
) do |args|

    raise(Puppet::ParseError, "deep_merge(): Define at least one hash " +
      "given (#{args.size} for 1)") if args.size < 1
      
    value  = args.shift
    
    if value.is_a?(Hash)
      args.each do |hash|
        if hash.is_a?(Hash)
          begin
            require 'deep_merge'
            value.deep_merge!(hash)        
          rescue LoadError
            value.merge(hash)
          end
        end
      end
    end
    return value
  end
end
