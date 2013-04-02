
define global::firewall (

  $resources = {},
  $overrides = {},
  $defaults  = {}

) {

  if ! empty($overrides) {
    $override_data = $overrides
  }
  else {
    $override_data = "${name}::firewall"
  }

  $data      = flatten([ $resources, $override_data ])
  $resources = global_resources('@firewall', $data, $defaults)
  realize Firewall[$resources]
}
