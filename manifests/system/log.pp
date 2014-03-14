
class corl::system::log {

  $base_name = "${corl::params::base_name}_log"

  # No configurations should be declared after this resource group.
  corl::file { $base_name:
    resources => {
      log_dir => {
        path => $corl::params::log_dir,
        ensure => 'directory',
        owner  => $corl::params::log_owner,
        group  => $corl::params::log_group,
        mode   => $corl::params::log_dir_mode
      },
      properties => {
        path    => $corl::params::property_path,
        ensure  => 'present',
        owner   => $corl::params::log_owner,
        group   => $corl::params::log_group,
        mode    => $corl::params::property_file_mode,
        require => 'log_dir'
      }
    }
  }
}
