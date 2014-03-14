
define corl::nagios_hostextinfo (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@nagios_hostextinfo', $data, $defaults, $name, $options)
  Nagios_hostextinfo<| tag == $name |>
}
