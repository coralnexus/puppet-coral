
define corl::nagios_hostgroup (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@nagios_hostgroup', $data, $defaults, $name, $options)
  Nagios_hostgroup<| tag == $name |>
}
