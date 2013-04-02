
define coral::packages (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $tag       = 'coral'

) {

  if ! empty($overrides) {
    $override_data = $overrides
  }
  else {
    $override_data = "${name}::packages"
  }

  if ! empty($defaults) {
    $default_data = $defaults
  }
  else {
    $default_data = "${name}::package_defaults"
  }

  $data = flatten([ $resources, $override_data ])
  coral_resources('@package', $data, $default_data, $tag)
  Package<| tag == $tag |>
}
