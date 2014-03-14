
define corl::firewallchain (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@firewallchain', $data, $defaults, $name, $options)
  Firewallchain<| tag == $name |>
}
