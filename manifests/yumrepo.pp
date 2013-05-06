
define coral::yumrepo (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@yumrepo', $data, $defaults, $name, $options)
  Yumrepo<| tag == $name |>
}
