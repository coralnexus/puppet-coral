
begin
require 'hiera/backend'
require 'hiera/recursive_lookup'

class Hiera
module Backend
  # Override Hiera parse_string method so we can further translate string values
  def parse_string(data, scope, extra_data = {})
    result = data
    if data.match(/^\s*(true|TRUE|True)\s*$/)
      result = true
    elsif data.match(/^\s*(false|FALSE|False)\s*$/)
      result = false
    elsif data.match(/^\s*(undef|UNDEF|Undef|nil|NIL|Nil)\s*$/)
      result = :undef
    else
      result = interpolate(data, Hiera::RecursiveLookup.new(scope, extra_data))
    end
    return result
  end
end
end

rescue LoadError
end
