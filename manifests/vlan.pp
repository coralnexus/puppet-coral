
define coral::vlan (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@vlan', $data, $defaults, $name, $options)
  Vlan<| tag == $name |>
}
