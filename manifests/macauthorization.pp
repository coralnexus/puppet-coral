
define coral::macauthorization (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@macauthorization', $data, $defaults, $name, $options)
  Macauthorization<| tag == $name |>
}
