
define coral::firewallchain (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@firewallchain', $data, $defaults, $name, $options)
  Firewallchain<| tag == $name |>
}
