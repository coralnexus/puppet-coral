
define corl::router (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@router', $data, $defaults, $name, $options)
  Router<| tag == $name |>
}
