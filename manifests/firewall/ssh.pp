
class corl::firewall::ssh {
  $base_name = $corl::params::base_name

  corl::firewall { "${base_name}_firewall_ssh":
    resources => {
      rule => {
        name   => $corl::params::ssh::firewall_name,
        action => 'accept',
        chain  => 'INPUT',
        state  => 'NEW',
        proto  => 'tcp',
        dport  => $corl::params::ssh::port
      }
    }
  }
}
