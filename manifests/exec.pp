
define coral::exec (

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

  if ! empty($defaults) {
    $default_data = $defaults
  }
  else {
    $default_data = "${name}::exec_defaults"
  }

  $data = flatten([ $resources, $override_data ])
  coral_resources('@exec', $data, $default_data, 'coral')
  Exec<| tag == 'coral' |>
}
