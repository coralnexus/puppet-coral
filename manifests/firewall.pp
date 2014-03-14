
define corl::firewall (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@firewall', $data, $defaults, $name, $options)
  Firewall<| tag == $name |>
}
