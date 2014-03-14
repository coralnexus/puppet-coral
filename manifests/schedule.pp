
define corl::schedule (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@schedule', $data, $defaults, $name, $options)
  Schedule<| tag == $name |>
}
