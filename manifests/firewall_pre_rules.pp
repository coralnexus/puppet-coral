
class global::firewall_pre_rules {
  global::firewall { 'global-firewall-pre-rules':
    resources => {
      'loopback-input' => {
        name    => '001 INPUT allow loopbacks',
        chain   => 'INPUT',
        iniface => 'lo',
        action  => 'accept'
      },
      'loopback-output' => {
        name     => '002 OUTPUT allow loopback',
        chain    => 'OUTPUT',
        outiface => 'lo',
        action   => 'accept'
      },
      'related-established' => {
        name   => '050 Allow related and established',
        state  => ['RELATED', 'ESTABLISHED'],
        action => 'accept',
      },
      'all-outbound' => {
        name   => '090 OUTPUT allow all outbound',
        chain  => 'OUTPUT',
        action => 'accept'
      }
    },
    defaults  => { require => undef },
    overrides => 'global::firewall_pre'
  }
}
