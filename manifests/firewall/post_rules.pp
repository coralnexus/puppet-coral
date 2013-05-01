
class coral::firewall::post_rules {
  $base_name = $coral::params::base_name

  coral::firewall { "${base_name}_firewall_post_rules":
    resources => {
      log_rejected => {
        name   => $coral::params::firewall_log_rejected_name,
        chain  => 'INPUT',
        jump   => 'LOG',
        limit  => '5/min'
      },
      reject_all => {
        name   => $coral::params::firewall_reject_all_name,
        chain  => ['INPUT', 'FORWARD'],
        action => 'reject'
      }
    },
    defaults => { before => undef }
  }
}
