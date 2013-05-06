
define coral::nagios_hostdependency (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@nagios_hostdependency', $data, $defaults, $name, $options)
  Nagios_hostdependency<| tag == $name |>
}
