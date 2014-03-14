
define corl::selboolean (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@selboolean', $data, $defaults, $name, $options)
  Selboolean<| tag == $name |>
}
