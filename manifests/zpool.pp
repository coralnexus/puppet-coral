
define coral::zpool (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@zpool', $data, $defaults, $name, $options)
  Zpool<| tag == $name |>
}
