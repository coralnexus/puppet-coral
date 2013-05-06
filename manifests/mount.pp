
define coral::mount (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@mount', $data, $defaults, $name, $options)
  Mount<| tag == $name |>
}
