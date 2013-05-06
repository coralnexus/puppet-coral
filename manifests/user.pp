
define coral::user (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@user', $data, $defaults, $name, $options)
  User<| tag == $name |>
}
