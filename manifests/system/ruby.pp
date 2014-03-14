
class corl::system::ruby inherits corl::params::ruby {

  $base_name   = $corl::params::base_name
  $system_name = $corl::params::ruby_name

  #-----------------------------------------------------------------------------
  # Installation

  corl::package { "${system_name}_core":
    resources => {
      packages => {
        name => $corl::params::ruby::package_names
      }
    },
    defaults  => {
      ensure => $corl::params::package_ensure
    },
    require => [ File["${system_name}_env"], Corl::Package[$base_name] ]
  }

  #---

  corl::package { "${system_name}_extra":
    resources => {
      packages  => {
        name => $corl::params::ruby::extra_package_names
      }
    },
    defaults  => {
      ensure => $corl::params::package_ensure
    },
    subscribe => Exec["${system_name}_active"],
    require => Corl::Package["${system_name}_core"]
  }

  #---

  corl::gem { $system_name:
    resources => {
      gems => {
        name => $corl::params::ruby::gem_names
      }
    },
    defaults => { ensure => $corl::params::ruby::gem_ensure },
    subscribe => Exec["${system_name}_gem_active"]
  }

  #-----------------------------------------------------------------------------
  # Configuration

  corl::file { $system_name:
    resources => {
      env => {
        path    => $corl::params::ruby::env_file,
        content => render($corl::params::env_template, $corl::params::ruby::variables)
      }
    }
  }

  #-----------------------------------------------------------------------------
  # Actions

  corl::exec { $system_name:
    resources => {
      active => {
        command     => $corl::params::ruby::set_active_command,
        refreshonly => true,
        subscribe   => Corl::Package["${system_name}_core"]
      },
      gem_active => {
        command     => $corl::params::ruby::gem_set_active_command,
        refreshonly => true,
        subscribe   => Corl::Package["${system_name}_core"]
      }
    }
  }
}
