
define corl::tidy (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@tidy', $data, $defaults, $name, $options)
  Tidy<| tag == $name |>
}
