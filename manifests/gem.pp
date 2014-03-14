
define corl::gem (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $ruby_name = $corl::params::ruby_name

  corl::package { "${name}_gem":
    resources => $resources,
    overrides => $overrides,
    defaults  => [ $defaults, { provider => 'gem' } ],
    options   => $options,
    require   => Corl::Package["${ruby_name}_extra"]
  }
}
