
define corl::stage (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@stage', $data, $defaults, $name, $options)
  Stage<| tag == $name |>
}
