
define coral::cron (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@cron', $data, $defaults, $name, $options)
  Cron<| tag == $name |>
}
