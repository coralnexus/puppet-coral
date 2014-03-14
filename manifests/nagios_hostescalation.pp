
define corl::nagios_hostescalation (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@nagios_hostescalation', $data, $defaults, $name, $options)
  Nagios_hostescalation<| tag == $name |>
}
