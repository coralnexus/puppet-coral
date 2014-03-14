
define corl::nagios_contact (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@nagios_contact', $data, $defaults, $name, $options)
  Nagios_contact<| tag == $name |>
}
