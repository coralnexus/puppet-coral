
define coral::file_line (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@file_line', $data, $defaults, $name, $options)
  File_line<| tag == $name |>
}
