
define global::repos (

  $resources = {},
  $overrides = {},
  $defaults  = {}

) {

  if ! empty($overrides) {
    $override_data = $overrides
  }
  else {
    $override_data = "${name}::repos"
  }

  $data      = flatten([ $resources, $override_data ])
  $resources = global_resources('@vcsrepo', $data, $defaults)
  realize Vcsrepo[$resources]
}
