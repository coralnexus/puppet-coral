
define coral::nagios_hostgroup (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@nagios_hostgroup', $data, $defaults, $name, $options)
  Nagios_hostgroup<| tag == $name |>
}
