
class coral::firewall_pre_rules {
  coral::firewall { coral_init:
    resources => {
      loopback_input => {
        name    => '001 INPUT allow loopbacks',
        chain   => 'INPUT',
        iniface => 'lo',
        action  => 'accept'
      },
      loopback_output => {
        name     => '002 OUTPUT allow loopback',
        chain    => 'OUTPUT',
        outiface => 'lo',
        action   => 'accept'
      },
      related_established => {
        name   => '050 Allow related and established',
        state  => ['RELATED', 'ESTABLISHED'],
        action => 'accept',
      },
      all_outbound => {
        name   => '090 OUTPUT allow all outbound',
        chain  => 'OUTPUT',
        action => 'accept'
      }
    },
    defaults => { require => undef }
  }
}
