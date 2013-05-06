
define coral::filebucket (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@filebucket', $data, $defaults, $name, $options)
  Filebucket<| tag == $name |>
}
