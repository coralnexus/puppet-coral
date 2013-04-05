
define coral::files (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@file', $data, $defaults, $name, $options)
  File<| tag == $name |>
}
