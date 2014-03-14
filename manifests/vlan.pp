
define corl::vlan (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@vlan', $data, $defaults, $name, $options)
  Vlan<| tag == $name |>
}
