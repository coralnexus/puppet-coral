
define coral::host (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@host', $data, $defaults, $name, $options)
  Host<| tag == $name |>
}
