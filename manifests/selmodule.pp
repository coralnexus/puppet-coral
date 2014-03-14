
define corl::selmodule (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@selmodule', $data, $defaults, $name, $options)
  Selmodule<| tag == $name |>
}
