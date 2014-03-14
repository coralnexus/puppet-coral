
define corl::nagios_servicedependency (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@nagios_servicedependency', $data, $defaults, $name, $options)
  Nagios_servicedependency<| tag == $name |>
}
