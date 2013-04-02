
define global::files (

  $resources = {},
  $overrides = {},
  $defaults  = {}

) {

  if ! empty($overrides) {
    $override_data = $overrides
  }
  else {
    $override_data = "${name}::files"
  }

  $data      = flatten([ $resources, $override_data ])
  $resources = global_resources('@file', $data, $defaults)
  realize File[$resources]
}
