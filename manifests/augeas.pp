
define corl::augeas (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@augeas', $data, $defaults, $name, $options)
  Augeas<| tag == $name |>
}
