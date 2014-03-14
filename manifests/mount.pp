
define corl::mount (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@mount', $data, $defaults, $name, $options)
  Mount<| tag == $name |>
}
