
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
    require => [ Corl::Package[$base_name], Corl::File[$system_name], Corl::Exec["${system_name}_package_init"] ]
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
      },
      root_gemrc => {
        path    => $corl::params::ruby::root_gemrc_file,
        content => $corl::params::ruby::root_gemrc
      }
    }
  }

  #-----------------------------------------------------------------------------
  # Actions

  #$package_helper = "${corl::params::base_name}_package_helper_${corl::params::package_helper}"

  corl::exec { "${system_name}_package_init":
    resources => {
      set_repository => {
        command     => ensure($corl::params::package_helper, $corl::params::ruby::set_repo_command),
        subscribe   => Corl::Package[$corl::params::base_name],
        refreshonly => true,
        notify      => 'package_update'
      },
      package_update => {
        command     => ensure($corl::params::package_helper, $corl::params::ruby::package_update_command),
        subscribe   => 'set_repository',
        refreshonly => true,
        notify      => Corl::Package["${system_name}_core"]
      }
    }
  }

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
