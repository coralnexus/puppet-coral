
class corl::firewall::icmp {
  $base_name = $corl::params::base_name

  corl::firewall { "${base_name}_firewall_icmp":
    resources => {
      rule => {
        name   => $corl::params::firewall_icmp_name,
        icmp   => '8',
        proto  => 'icmp',
        action => 'accept'
      }
    }
  }
}
