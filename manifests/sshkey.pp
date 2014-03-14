
define corl::sshkey (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@sshkey', $data, $defaults, $name, $options)
  Sshkey<| tag == $name |>
}
