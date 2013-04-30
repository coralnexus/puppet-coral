
define coral::gems (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $base_name = $coral::params::base_name

  coral::packages { "${name}_gem":
    resources => $resources,
    overrides => $overrides,
    defaults  => [ $defaults, { provider => 'gem' } ],
    options   => $options,
    require   => File["${base_name}_ruby_env"]
  }
}
