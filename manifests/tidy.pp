
define coral::tidy (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@tidy', $data, $defaults, $name, $options)
  Tidy<| tag == $name |>
}
