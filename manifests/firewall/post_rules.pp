
class corl::firewall::post_rules {
  $base_name = $corl::params::base_name

  corl::firewall { "${base_name}_firewall_post_rules":
    resources => {
      log_rejected => {
        name   => $corl::params::firewall_log_rejected_name,
        chain  => 'INPUT',
        jump   => 'LOG',
        limit  => '5/min'
      },
      reject_all => {
        name   => $corl::params::firewall_reject_all_name,
        chain  => ['INPUT', 'FORWARD'],
        action => 'reject'
      }
    },
    defaults => { before => undef }
  }
}
