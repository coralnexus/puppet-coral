
define corl::computer (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@computer', $data, $defaults, $name, $options)
  Computer<| tag == $name |>
}
