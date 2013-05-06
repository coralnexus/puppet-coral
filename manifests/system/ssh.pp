
class coral::system::ssh inherits coral::params::ssh {

  $base_name   = $coral::params::base_name
  $system_name = $coral::params::ssh_name

  #-----------------------------------------------------------------------------
  # Installation

  coral::package { $system_name:
    resources => {
      core_packages => {
        name => $coral::params::ssh::package_names
      },
      extra_packages  => {
        name    => $coral::params::ssh::extra_package_names,
        require => 'core_packages'
      }
    },
    defaults  => {
      ensure => $coral::params::package_ensure
    },
    require => Coral::Package[$base_name]
  }

  #-----------------------------------------------------------------------------
  # Configuration

  coral::file { $system_name:
    resources => {
      conf => {
        path     => $coral::params::ssh::config_file,
        content  => render($coral::params::ssh::config_template, $coral::params::ssh::config),
        owner    => $coral::params::ssh::config_owner,
        group    => $coral::params::ssh::config_group,
        mode     => $coral::params::ssh::config_mode,
        require  => Coral::Package[$system_name]
      }
    },
    defaults => { notify => Service["${system_name}_service"] }
  }

  #---

  include coral::firewall::ssh

  #-----------------------------------------------------------------------------
  # Actions

  coral::exec { $system_name:
    resources => {
      reload => {
        command     => $coral::params::ssh::init_command,
        refreshonly => true,
        subscribe   => File["${system_name}_conf"]
      }
    }
  }

  #-----------------------------------------------------------------------------
  # Services

  coral::service { $system_name:
    resources => {
      service => {
        name   => $coral::params::ssh::service_name,
        ensure => $coral::params::ssh::service_ensure,
      }
    },
    require => [ Coral::Service[$base_name], Coral::Package[$system_name] ]
  }

  #---

  coral::cron { $system_name:
    require => Coral::Service[$system_name]
  }
}
