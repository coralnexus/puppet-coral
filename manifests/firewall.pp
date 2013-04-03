
define coral::firewall (

  $resources = {},
  $overrides = {},
  $defaults  = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@firewall', $data, $defaults, $name)
  Firewall<| tag == $name |>
}
