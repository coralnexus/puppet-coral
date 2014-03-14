
define corl::scheduled_task (

  $resources = {},
  $overrides = {},
  $defaults  = {},
  $options   = {}

) {
  $data = flatten([ $resources, $overrides ])
  corl_resources('@scheduled_task', $data, $defaults, $name, $options)
  Scheduled_task<| tag == $name |>
}
