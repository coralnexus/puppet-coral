
define coral::vcsrepo (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@vcsrepo', $data, $defaults, $name, $options)
  Vcsrepo<| tag == $name |>
}
