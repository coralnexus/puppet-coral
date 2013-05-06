
define coral::nagios_hostextinfo (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@nagios_hostextinfo', $data, $defaults, $name, $options)
  Nagios_hostextinfo<| tag == $name |>
}
