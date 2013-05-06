
define coral::augeas (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@augeas', $data, $defaults, $name, $options)
  Augeas<| tag == $name |>
}
