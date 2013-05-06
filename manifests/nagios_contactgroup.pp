
define coral::nagios_contactgroup (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@nagios_contactgroup', $data, $defaults, $name, $options)
  Nagios_contactgroup<| tag == $name |>
}
