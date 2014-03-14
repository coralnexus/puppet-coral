
define corl::nagios_command (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@nagios_command', $data, $defaults, $name, $options)
  Nagios_command<| tag == $name |>
}
