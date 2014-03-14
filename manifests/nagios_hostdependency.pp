
define corl::nagios_hostdependency (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@nagios_hostdependency', $data, $defaults, $name, $options)
  Nagios_hostdependency<| tag == $name |>
}
