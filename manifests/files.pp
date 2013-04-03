
define coral::files (

  $resources = {},
  $overrides = {},
  $defaults  = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@file', $data, $defaults, $name)
  File<| tag == $name |>
}
