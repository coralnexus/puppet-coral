
define global::packages (

  $resources = {},
  $overrides = {},
  $defaults  = {}

) {

  if ! empty($overrides) {
    $override_data = $overrides
  }
  else {
    $override_data = "${name}::packages"
  }

  $data      = flatten([ $resources, $override_data ])
  $resources = global_resources('@package', $data, $defaults)
  realize Package[$resources]
}
