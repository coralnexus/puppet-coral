
define corl::group (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@group', $data, $defaults, $name, $options)
  Group<| tag == $name |>
}
