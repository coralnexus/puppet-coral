
define corl::file (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@file', $data, $defaults, $name, $options)
  File<| tag == $name |>
}
