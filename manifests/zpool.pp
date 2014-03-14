
define corl::zpool (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@zpool', $data, $defaults, $name, $options)
  Zpool<| tag == $name |>
}
