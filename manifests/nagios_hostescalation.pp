
define coral::nagios_hostescalation (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@nagios_hostescalation', $data, $defaults, $name, $options)
  Nagios_hostescalation<| tag == $name |>
}
