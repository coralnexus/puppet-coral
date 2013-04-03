
define coral::packages (

  $resources = {},
  $overrides = {},
  $defaults  = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@package', $data, $defaults, $name)
  Package<| tag == $name |>
}
