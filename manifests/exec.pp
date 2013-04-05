
define coral::exec (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@exec', $data, $defaults, $name, $options)
  Exec<| tag == $name |>
}
