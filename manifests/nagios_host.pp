
define coral::nagios_host (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@nagios_host', $data, $defaults, $name, $options)
  Nagios_host<| tag == $name |>
}
