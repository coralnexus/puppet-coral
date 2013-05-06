
define coral::sshkey (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@sshkey', $data, $defaults, $name, $options)
  Sshkey<| tag == $name |>
}
