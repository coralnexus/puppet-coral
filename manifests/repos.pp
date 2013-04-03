
define coral::repos (

  $resources = {},
  $overrides = {},
  $defaults  = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@vcsrepo', $data, $defaults, $name)
  Vcsrepo<| tag == $name |>
}
