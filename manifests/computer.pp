
define coral::computer (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@computer', $data, $defaults, $name, $options)
  Computer<| tag == $name |>
}
