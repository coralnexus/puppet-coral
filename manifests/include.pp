
define coral::include (

  $classes    = $name,
  $parameters = {},
  $options    = {}

) {

  anchor { $name: }

  $merged_parameters = deep_merge({ require => Anchor[$name] }, $parameters)
  coral_include($classes, $merged_parameters, $options)
}
