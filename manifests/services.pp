
define coral::services (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@service', $data, $defaults, $name, $options)
  Service<| tag == $name |>
}
