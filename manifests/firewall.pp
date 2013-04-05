
define coral::firewall (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@firewall', $data, $defaults, $name, $options)
  Firewall<| tag == $name |>
}
