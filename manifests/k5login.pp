
define coral::k5login (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@k5login', $data, $defaults, $name, $options)
  K5login<| tag == $name |>
}
