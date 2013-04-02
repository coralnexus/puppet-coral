
define global::services (

  $resources = {},
  $overrides = {},
  $defaults  = {}

) {

  if ! empty($overrides) {
    $override_data = $overrides
  }
  else {
    $override_data = "${name}::services"
  }

  $data      = flatten([ $resources, $override_data ])
  $resources = global_resources('@service', $data, $defaults)
  realize Service[$resources]
}
