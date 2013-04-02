
define global::cron (

  $resources = {},
  $overrides = {},
  $defaults  = {}

) {

  if ! empty($overrides) {
    $override_data = $overrides
  }
  else {
    $override_data = "${name}::cron"
  }

  $data      = flatten([ $resources, $override_data ])
  $resources = global_resources('@cron', $data, $defaults)
  realize Cron[$resources]
}
