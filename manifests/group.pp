
define coral::group (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@group', $data, $defaults, $name, $options)
  Group<| tag == $name |>
}
