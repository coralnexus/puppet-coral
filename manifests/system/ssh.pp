
class corl::system::ssh inherits corl::params::ssh {

  $base_name   = $corl::params::base_name
  $system_name = $corl::params::ssh_name

  #-----------------------------------------------------------------------------
  # Installation

  corl::package { $system_name:
    resources => {
      core_packages => {
        name => $corl::params::ssh::package_names
      },
      extra_packages  => {
        name    => $corl::params::ssh::extra_package_names,
        require => 'core_packages'
      }
    },
    defaults  => {
      ensure => $corl::params::package_ensure
    },
    require => Corl::Package[$base_name]
  }

  #-----------------------------------------------------------------------------
  # Configuration

  corl::file { $system_name:
    resources => {
      sshd_conf => {
        path    => $corl::params::ssh::sshd_config_file,
        content => render($corl::params::ssh::config_template, $corl::params::ssh::sshd_config),
        notify  => Service["${system_name}_service"]
      },
      ssh_conf => {
        path    => $corl::params::ssh::ssh_config_file,
        content => render($corl::params::ssh::config_template, $corl::params::ssh::ssh_config)
      }
    },
    defaults => {
      owner   => $corl::params::ssh::config_owner,
      group   => $corl::params::ssh::config_group,
      mode    => $corl::params::ssh::config_mode,
      require => Corl::Package[$system_name]       
    }
  }

  #---

  include corl::firewall::ssh

  #-----------------------------------------------------------------------------
  # Actions

  corl::exec { $system_name:
    resources => {
      reload => {
        command     => $corl::params::ssh::init_command,
        refreshonly => true,
        subscribe   => File["${system_name}_sshd_conf"]
      }
    }
  }

  #-----------------------------------------------------------------------------
  # Services

  corl::service { $system_name:
    resources => {
      service => {
        name   => $corl::params::ssh::service_name,
        ensure => $corl::params::ssh::service_ensure,
      }
    },
    require => [ Corl::Service[$base_name], Corl::Package[$system_name] ]
  }

  #---

  corl::cron { $system_name:
    require => Corl::Service[$system_name]
  }
}
