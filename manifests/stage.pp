
define coral::stage (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@stage', $data, $defaults, $name, $options)
  Stage<| tag == $name |>
}
