
define corl::zfs (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@zfs', $data, $defaults, $name, $options)
  Zfs<| tag == $name |>
}
