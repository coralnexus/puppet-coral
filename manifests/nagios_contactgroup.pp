
define corl::nagios_contactgroup (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@nagios_contactgroup', $data, $defaults, $name, $options)
  Nagios_contactgroup<| tag == $name |>
}
