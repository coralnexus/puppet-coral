
define corl::mcx (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@mcx', $data, $defaults, $name, $options)
  Mcx<| tag == $name |>
}
