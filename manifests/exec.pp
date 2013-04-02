
define global::exec (

  $resources = {},
  $overrides = {},
  $defaults  = {}

) {

  if ! empty($overrides) {
    $override_data = $overrides
  }
  else {
    $override_data = "${name}::exec"
  }

  $data      = flatten([ $resources, $override_data ])
  $resources = global_resources('@exec', $data, $defaults)
  realize Exec[$resources]
}
