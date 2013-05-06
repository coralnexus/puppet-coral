
define coral::selboolean (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@selboolean', $data, $defaults, $name, $options)
  Selboolean<| tag == $name |>
}
