
define corl::file_line (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@file_line', $data, $defaults, $name, $options)
  File_line<| tag == $name |>
}
