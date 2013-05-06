
define coral::maillist (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@maillist', $data, $defaults, $name, $options)
  Maillist<| tag == $name |>
}
