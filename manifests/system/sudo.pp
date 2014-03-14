
class corl::system::sudo inherits corl::params::sudo {

  $base_name   = $corl::params::base_name
  $system_name = $corl::params::sudo_name

  #-----------------------------------------------------------------------------
  # Configuration

  $sudoers_config_render = render($corl::params::sudo::sudoers_template, $corl::params::sudo::sudoers_config)
  $sudoers_dir = $corl::params::sudo::sudoers_dir

  corl::file { $system_name:
    resources => {
      test_conf => {
        path    => $corl::params::sudo::sudoers_test_file,
        content => template($corl::params::sudo::sudoers_template_file)
      },
      conf => {
        path      => $corl::params::sudo::sudoers_file,
        source    => $corl::params::sudo::sudoers_test_file,
        subscribe => Exec["${system_name}_test"],
      }
    },
    defaults => {
      owner => $corl::params::sudo::sudoers_config_owner,
      group => $corl::params::sudo::sudoers_config_group,
      mode  => $corl::params::sudo::sudoers_config_mode
    }
  }

  #-----------------------------------------------------------------------------
  # Actions

  corl::exec { $system_name:
    resources => {
      test => {
        command     => $corl::params::sudo::sudoers_test_command,
        refreshonly => true,
        subscribe   => File["${system_name}_test_conf"]
      }
    }
  }
}
