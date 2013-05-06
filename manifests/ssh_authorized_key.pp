
define coral::ssh_authorized_key (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@ssh_authorized_key', $data, $defaults, $name, $options)
  Ssh_authorized_key<| tag == $name |>
}
