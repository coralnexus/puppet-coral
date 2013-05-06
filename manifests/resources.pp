
define coral::resources (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@resources', $data, $defaults, $name, $options)
  Resources<| tag == $name |>
}
