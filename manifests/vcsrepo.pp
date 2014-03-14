
define corl::vcsrepo (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@vcsrepo', $data, $defaults, $name, $options)
  Vcsrepo<| tag == $name |>
}
