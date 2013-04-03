
class coral::firewall_post_rules {
  coral::firewall { coral_exit:
    resources => {
      log_rejected => {
        name   => '950 INPUT log all rejected',
        chain  => 'INPUT',
        jump   => 'LOG',
        limit  => '5/min'
      },
      reject_all => {
        name   => '999 Reject all',
        chain  => ['INPUT', 'FORWARD'],
        action => 'reject'
      }
    },
    defaults => { before => undef }
  }
}
