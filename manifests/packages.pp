
define coral::packages (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@package', $data, $defaults, $name, $options)
  Package<| tag == $name |>
}
