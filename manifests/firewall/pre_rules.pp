
class corl::firewall::pre_rules {
  $base_name = $corl::params::base_name

  corl::firewall { "${base_name}_firewall_pre_rules":
    resources => {
      loopback_input => {
        name    => $corl::params::firewall_loopback_input_name,
        chain   => 'INPUT',
        iniface => 'lo',
        action  => 'accept'
      },
      loopback_output => {
        name     => $corl::params::firewall_loopback_output_name,
        chain    => 'OUTPUT',
        outiface => 'lo',
        action   => 'accept'
      },
      related_established => {
        name   => $corl::params::firewall_related_established_name,
        state  => ['RELATED', 'ESTABLISHED'],
        action => 'accept',
      },
      all_outbound => {
        name   => $corl::params::firewall_all_outbound_name,
        chain  => 'OUTPUT',
        action => 'accept'
      }
    },
    defaults => { require => undef }
  }
}
