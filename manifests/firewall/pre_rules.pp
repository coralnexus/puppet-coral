
class coral::firewall::pre_rules {
  $base_name = $coral::params::base_name

  coral::firewall { "${base_name}_firewall_pre_rules":
    resources => {
      loopback_input => {
        name    => $coral::params::firewall_loopback_input_name,
        chain   => 'INPUT',
        iniface => 'lo',
        action  => 'accept'
      },
      loopback_output => {
        name     => $coral::params::firewall_loopback_output_name,
        chain    => 'OUTPUT',
        outiface => 'lo',
        action   => 'accept'
      },
      related_established => {
        name   => $coral::params::firewall_related_established_name,
        state  => ['RELATED', 'ESTABLISHED'],
        action => 'accept',
      },
      all_outbound => {
        name   => $coral::params::firewall_all_outbound_name,
        chain  => 'OUTPUT',
        action => 'accept'
      }
    },
    defaults => { require => undef }
  }
}
