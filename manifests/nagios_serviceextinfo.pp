
define coral::nagios_serviceextinfo (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@nagios_serviceextinfo', $data, $defaults, $name, $options)
  Nagios_serviceextinfo<| tag == $name |>
}
