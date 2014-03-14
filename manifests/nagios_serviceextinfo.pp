
define corl::nagios_serviceextinfo (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@nagios_serviceextinfo', $data, $defaults, $name, $options)
  Nagios_serviceextinfo<| tag == $name |>
}
