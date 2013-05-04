
define coral::gem (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $ruby_name = $coral::params::ruby_name

  coral::package { "${name}_gem":
    resources => $resources,
    overrides => $overrides,
    defaults  => [ $defaults, { provider => 'gem' } ],
    options   => $options,
    require   => Coral::Package["${ruby_name}_extra"]
  }
}
