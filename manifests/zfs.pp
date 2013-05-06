
define coral::zfs (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@zfs', $data, $defaults, $name, $options)
  Zfs<| tag == $name |>
}
