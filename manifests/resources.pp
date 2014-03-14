
define corl::resources (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@resources', $data, $defaults, $name, $options)
  Resources<| tag == $name |>
}
