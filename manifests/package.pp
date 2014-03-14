
define corl::package (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@package', $data, $defaults, $name, $options)
  Package<| tag == $name |>
}
