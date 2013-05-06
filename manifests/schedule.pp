
define coral::schedule (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@schedule', $data, $defaults, $name, $options)
  Schedule<| tag == $name |>
}
