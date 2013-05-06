
define coral::nagios_servicedependency (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@nagios_servicedependency', $data, $defaults, $name, $options)
  Nagios_servicedependency<| tag == $name |>
}
