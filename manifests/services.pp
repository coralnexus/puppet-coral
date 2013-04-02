
define coral::services (

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

  if ! empty($defaults) {
    $default_data = $defaults
  }
  else {
    $default_data = "${name}::service_defaults"
  }

  $data = flatten([ $resources, $override_data ])
  coral_resources('@service', $data, $default_data, 'coral')
  Service<| tag == 'coral' |>
}
