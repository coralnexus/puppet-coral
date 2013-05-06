
define coral::interface (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@interface', $data, $defaults, $name, $options)
  Interface<| tag == $name |>
}
