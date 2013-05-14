
class coral::system::log {

  $base_name = "${coral::params::base_name}_log"

  # No configurations should be declared after this resource group.
  coral::file { $base_name:
    resources => {
      log_dir => {
        path => $coral::params::log_dir,
        ensure => 'directory',
        owner  => $coral::params::log_owner,
        group  => $coral::params::log_group,
        mode   => $coral::params::log_dir_mode
      },
      properties => {
        path    => $coral::params::property_path,
        ensure  => 'present',
        owner   => $coral::params::log_owner,
        group   => $coral::params::log_group,
        mode    => $coral::params::property_file_mode,
        require => 'log_dir'
      }
    }
  }
}
