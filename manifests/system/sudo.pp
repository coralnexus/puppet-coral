
class coral::system::sudo inherits coral::params::sudo {

  $base_name   = $coral::params::base_name
  $system_name = $coral::params::sudo_name

  #-----------------------------------------------------------------------------
  # Configuration

  $sudoers_config_render = render($coral::params::sudo::sudoers_template, $coral::params::sudo::sudoers_config)
  $sudoers_dir = $coral::params::sudo::sudoers_dir

  coral::file { $system_name:
    resources => {
      test_conf => {
        path    => $coral::params::sudo::sudoers_test_file,
        content => template($coral::params::sudo::sudoers_template_file)
      },
      conf => {
        path      => $coral::params::sudo::sudoers_file,
        source    => $coral::params::sudo::sudoers_test_file,
        subscribe => Exec["${system_name}_test"],
      }
    },
    defaults => {
      owner => $coral::params::sudo::sudoers_config_owner,
      group => $coral::params::sudo::sudoers_config_group,
      mode  => $coral::params::sudo::sudoers_config_mode
    }
  }

  #-----------------------------------------------------------------------------
  # Actions

  coral::exec { $system_name:
    resources => {
      test => {
        command     => $coral::params::sudo::sudoers_test_command,
        refreshonly => true,
        subscribe   => File["${system_name}_test_conf"]
      }
    }
  }
}
