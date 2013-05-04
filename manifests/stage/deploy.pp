
class coral::stage::deploy {
  $base_name = $coral::params::base_name
  $stage_name = $coral::params::deploy_name

  #-----------------------------------------------------------------------------
  # Logging

  $property_dir = $coral::params::property_dir
  $property_file = $coral::params::property_file
  $property_path = "${property_dir}/${property_file}"

  coral::file { $stage_name:
    resources => {
      properties => {
        path   => $coral::params::generate_properties ? { true => $property_path, default => '' },
        content => render($coral::params::json_template, configuration()),
        ensure => 'present',
        owner  => $coral::params::property_owner,
        group  => $coral::params::property_group,
        mode   => $coral::params::property_file_mode
      }
    }
  }
}
