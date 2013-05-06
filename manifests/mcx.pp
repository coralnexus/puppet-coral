
define coral::mcx (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@mcx', $data, $defaults, $name, $options)
  Mcx<| tag == $name |>
}
