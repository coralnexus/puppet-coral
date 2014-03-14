
define corl::nagios_timeperiod (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@nagios_timeperiod', $data, $defaults, $name, $options)
  Nagios_timeperiod<| tag == $name |>
}
