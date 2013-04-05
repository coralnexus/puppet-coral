#
# normalize.rb
#
# Merges and looks up data and possible overrides and composes the 
# merged results back into a normalized hash. 
#
module Puppet::Parser::Functions
  newfunction(:normalize, :type => :rvalue, :doc => <<-EOS
This function merges and looks up data and possible overrides and composes the 
merged results back into a normalized hash. 
    EOS
) do |args|

    raise(Puppet::ParseError, "normalize(): Define a data object and optionally an override to normalize " +
      "given (#{args.size} for 2)") if args.size < 1
      
    data     = args[0]
    override = ( args[1] ? args[1] : nil )
    options  = ( args[2] ? args[2] : {} )
    
    config = Coral::Config.new(options, {
      :scope     => self,
      :init_fact => 'hiera_ready',
      :search    => 'coral::default'
    })
    return Coral::Data.normalize(data, override, config)
  end
end
