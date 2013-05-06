
define coral::anchor (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@anchor', $data, $defaults, $name, $options)
  Anchor<| tag == $name |>
}
