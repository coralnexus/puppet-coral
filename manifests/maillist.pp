
define corl::maillist (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@maillist', $data, $defaults, $name, $options)
  Maillist<| tag == $name |>
}
