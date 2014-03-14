
define corl::zone (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@zone', $data, $defaults, $name, $options)
  Zone<| tag == $name |>
}
