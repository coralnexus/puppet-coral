
define coral::services (

  $resources = {},
  $overrides = {},
  $defaults  = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@service', $data, $defaults, $name)
  Service<| tag == $name |>
}
