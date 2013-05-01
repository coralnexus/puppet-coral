
class coral::firewall::icmp {
  $base_name = $coral::params::base_name

  coral::firewall { "${base_name}_firewall_icmp":
    resources => {
      rule => {
        name   => $coral::params::firewall_icmp_name,
        icmp   => '8',
        proto  => 'icmp',
        action => 'accept'
      }
    }
  }
}
