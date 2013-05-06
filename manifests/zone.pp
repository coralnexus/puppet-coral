
define coral::zone (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@zone', $data, $defaults, $name, $options)
  Zone<| tag == $name |>
}
