
define coral::scheduled_task (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  coral_resources('@scheduled_task', $data, $defaults, $name, $options)
  Scheduled_task<| tag == $name |>
}
