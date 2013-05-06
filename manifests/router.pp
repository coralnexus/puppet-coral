
define coral::router (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@router', $data, $defaults, $name, $options)
  Router<| tag == $name |>
}
