
class coral::firewall::ssh {
  $base_name = $coral::params::base_name

  coral::firewall { "${base_name}_firewall_ssh":
    resources => {
      rule => {
        name   => $coral::params::firewall_ssh_name,
        action => 'accept',
        chain  => 'INPUT',
        state  => 'NEW',
        proto  => 'tcp',
        dport  => $coral::params::ssh_port
      }
    }
  }
}
