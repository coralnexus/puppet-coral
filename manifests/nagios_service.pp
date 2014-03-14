
define corl::nagios_service (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@nagios_service', $data, $defaults, $name, $options)
  Nagios_service<| tag == $name |>
}
