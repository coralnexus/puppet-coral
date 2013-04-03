
define coral::exec (

  $resources = {},
  $overrides = {},
  $defaults  = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@exec', $data, $defaults, $name)
  Exec<| tag == $name |>
}
