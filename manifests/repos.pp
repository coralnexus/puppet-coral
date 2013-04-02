
define coral::repos (

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

  if ! empty($defaults) {
    $default_data = $defaults
  }
  else {
    $default_data = "${name}::repo_defaults"
  }

  $data = flatten([ $resources, $override_data ])
  coral_resources('@vcsrepo', $data, $default_data, 'coral')
  Vcsrepo<| tag == 'coral' |>
}
