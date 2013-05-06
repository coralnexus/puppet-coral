
define coral::selmodule (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@selmodule', $data, $defaults, $name, $options)
  Selmodule<| tag == $name |>
}
