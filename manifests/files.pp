
define coral::files (

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

  if ! empty($defaults) {
    $default_data = $defaults
  }
  else {
    $default_data = "${name}::file_defaults"
  }

  $data = flatten([ $resources, $override_data ])
  coral_resources('@file', $data, $default_data, 'coral')
  File<| tag == 'coral' |>
}
