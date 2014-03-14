
define corl::nagios_serviceescalation (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@nagios_serviceescalation', $data, $defaults, $name, $options)
  Nagios_serviceescalation<| tag == $name |>
}
