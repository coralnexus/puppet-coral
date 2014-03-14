
define corl::service (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@service', $data, $defaults, $name, $options)
  Service<| tag == $name |>
}
