
define coral::cron (

  $resources = {},
  $overrides = {},
  $defaults  = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@cron', $data, $defaults, $name)
  Cron<| tag == $name |>
}
