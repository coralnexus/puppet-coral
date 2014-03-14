
define corl::host (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@host', $data, $defaults, $name, $options)
  Host<| tag == $name |>
}
