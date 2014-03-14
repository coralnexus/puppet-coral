
define corl::macauthorization (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@macauthorization', $data, $defaults, $name, $options)
  Macauthorization<| tag == $name |>
}
