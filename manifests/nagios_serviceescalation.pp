
define coral::nagios_serviceescalation (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@nagios_serviceescalation', $data, $defaults, $name, $options)
  Nagios_serviceescalation<| tag == $name |>
}
