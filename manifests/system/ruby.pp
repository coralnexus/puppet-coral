
class coral::system::ruby {
  $base_name = $coral::params::base_name
  $system_name = $coral::params::ruby_name

  #-----------------------------------------------------------------------------
  # Installation

  coral::package { $system_name:
    resources => {
      dev_packages  => {
        name => $coral::params::ruby_dev_package_names
      },
      common_packages => {
        name    => $coral::params::ruby_package_names,
        require => 'dev_packages'
      },
      extra_packages  => {
        name    => $coral::params::ruby_extra_package_names,
        require => 'common_packages',
        subscribe => Exec["${system_name}_active"]
      }
    },
    defaults  => {
      ensure => $coral::params::package_ensure
    },
    require => [ File["${system_name}_env"], Coral::Package[$base_name] ]
  }

  #---

  coral::gem { $system_name:
    resources => {
      gems => {
        name => $coral::params::gem_names
      }
    },
    defaults => { ensure => $coral::params::gem_ensure },
    subscribe => Exec["${system_name}_gem_active"]
  }

  #-----------------------------------------------------------------------------
  # Configuration

  coral::file { $system_name:
    resources => {
      env => {
        path    => $coral::params::ruby_env_file,
        content => render($coral::params::env_template, $coral::params::ruby_variables)
      }
    }
  }

  #-----------------------------------------------------------------------------
  # Actions

  coral::exec { $system_name:
    resources => {
      active => {
        command     => $coral::params::ruby_set_active_command,
        refreshonly => true,
        subscribe   => Package["${system_name}_common_packages"]
      },
      gem_active => {
        command     => $coral::params::gem_set_active_command,
        refreshonly => true,
        subscribe   => Package["${system_name}_extra_packages"]
      }
    }
  }
}
