
define corl::user (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@user', $data, $defaults, $name, $options)
  User<| tag == $name |>
}
