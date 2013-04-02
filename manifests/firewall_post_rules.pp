
class coral::firewall_post_rules {
  coral::firewall { 'coral-firewall-post-rules':
    resources => {
      'log-rejected' => {
        name   => '950 INPUT log all rejected',
        chain  => 'INPUT',
        jump   => 'LOG',
        limit  => '5/min'
      },
      'reject-all' => {
        name   => '999 Reject all',
        chain  => ['INPUT', 'FORWARD'],
        action => 'reject'
      }
    },
    defaults  => [ { before => undef }, 'coral::firewall_post_defaults' ],
    overrides => 'coral::firewall_post_rules'
  }
}
