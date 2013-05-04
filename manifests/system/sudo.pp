
class coral::system::sudo {
  $base_name = $coral::params::base_name
  $system_name = $coral::params::sudo_name

  #-----------------------------------------------------------------------------
  # Configuration

  $sudoers_config_render = render($coral::params::sudoers_template, $coral::params::sudoers_config)
  $sudoers_dir = $coral::params::sudoers_dir

  coral::file { $system_name:
    resources => {
      test_conf => {
        path    => $coral::params::sudoers_test_file,
        content => template($coral::params::sudoers_template_file)
      },
      conf => {
        path      => $coral::params::sudoers_file,
        source    => $coral::params::sudoers_test_file,
        subscribe => Exec["${system_name}_test"],
      }
    },
    defaults => {
      owner => $coral::params::sudoers_config_owner,
      group => $coral::params::sudoers_config_group,
      mode  => $coral::params::sudoers_config_mode
    }
  }

  #-----------------------------------------------------------------------------
  # Actions

  coral::exec { $system_name:
    resources => {
      test => {
        command     => $coral::params::sudoers_test_command,
        refreshonly => true,
        subscribe   => File["${system_name}_test_conf"]
      }
    }
  }
}
