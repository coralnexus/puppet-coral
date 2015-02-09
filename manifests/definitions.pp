
define corl::definitions (

  $type      = undef,
  $resources = {},
  $defaults  = {},
  $options   = {}

) {
  if $type != undef {
    corl_resources($type, [ $resources, $name ], $defaults, '', $options)
  }
}
