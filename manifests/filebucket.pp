
define corl::filebucket (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@filebucket', $data, $defaults, $name, $options)
  Filebucket<| tag == $name |>
}
