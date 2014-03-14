
define corl::interface (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@interface', $data, $defaults, $name, $options)
  Interface<| tag == $name |>
}
