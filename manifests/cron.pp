
define corl::cron (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@cron', $data, $defaults, $name, $options)
  Cron<| tag == $name |>
}
