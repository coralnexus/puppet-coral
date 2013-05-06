
define coral::nagios_command (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@nagios_command', $data, $defaults, $name, $options)
  Nagios_command<| tag == $name |>
}
