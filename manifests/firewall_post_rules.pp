
class global::firewall_post_rules {
  global::firewall { 'global-firewall-post-rules':
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
    defaults  => { before => undef },
    overrides => 'global::firewall_post'
  }
}
