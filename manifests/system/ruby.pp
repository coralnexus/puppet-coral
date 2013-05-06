
class coral::system::ruby inherits coral::params::ruby {

  $base_name   = $coral::params::base_name
  $system_name = $coral::params::ruby_name

  #-----------------------------------------------------------------------------
  # Installation

  coral::package { "${system_name}_core":
    resources => {
      packages => {
        name => $coral::params::ruby::package_names
      }
    },
    defaults  => {
      ensure => $coral::params::package_ensure
    },
    require => [ File["${system_name}_env"], Coral::Package[$base_name] ]
  }

  #---

  coral::package { "${system_name}_extra":
    resources => {
      packages  => {
        name => $coral::params::ruby::extra_package_names
      }
    },
    defaults  => {
      ensure => $coral::params::package_ensure
    },
    subscribe => Exec["${system_name}_active"],
    require => Coral::Package["${system_name}_core"]
  }

  #---

  coral::gem { $system_name:
    resources => {
      gems => {
        name => $coral::params::ruby::gem_names
      }
    },
    defaults => { ensure => $coral::params::ruby::gem_ensure },
    subscribe => Exec["${system_name}_gem_active"]
  }

  #-----------------------------------------------------------------------------
  # Configuration

  coral::file { $system_name:
    resources => {
      env => {
        path    => $coral::params::ruby::env_file,
        content => render($coral::params::env_template, $coral::params::ruby::variables)
      }
    }
  }

  #-----------------------------------------------------------------------------
  # Actions

  coral::exec { $system_name:
    resources => {
      active => {
        command     => $coral::params::ruby::set_active_command,
        refreshonly => true,
        subscribe   => Coral::Package["${system_name}_core"]
      },
      gem_active => {
        command     => $coral::params::ruby::gem_set_active_command,
        refreshonly => true,
        subscribe   => Coral::Package["${system_name}_extra"]
      }
    }
  }
}
