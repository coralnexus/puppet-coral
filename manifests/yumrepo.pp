
define corl::yumrepo (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@yumrepo', $data, $defaults, $name, $options)
  Yumrepo<| tag == $name |>
}
