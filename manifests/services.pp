
define coral::services (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $tag       = 'coral'

) {

  if ! empty($overrides) {
    $override_data = $overrides
  }
  else {
    $override_data = "${name}::services"
  }

  if ! empty($defaults) {
    $default_data = $defaults
  }
  else {
    $default_data = "${name}::service_defaults"
  }

  $data = flatten([ $resources, $override_data ])
  coral_resources('@service', $data, $default_data, $tag)
  Service<| tag == $tag |>
}
