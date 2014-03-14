
define corl::mailalias (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@mailalias', $data, $defaults, $name, $options)
  Mailalias<| tag == $name |>
}
