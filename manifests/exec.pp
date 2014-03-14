
define corl::exec (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@exec', $data, $defaults, $name, $options)
  Exec<| tag == $name |>
}
