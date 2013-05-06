
define coral::mailalias (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@mailalias', $data, $defaults, $name, $options)
  Mailalias<| tag == $name |>
}
