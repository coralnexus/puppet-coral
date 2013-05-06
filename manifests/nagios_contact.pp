
define coral::nagios_contact (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@nagios_contact', $data, $defaults, $name, $options)
  Nagios_contact<| tag == $name |>
}
