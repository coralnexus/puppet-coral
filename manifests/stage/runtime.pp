
class coral::stage::runtime {

  $base_name = $coral::params::base_name
  $stage_name = $coral::params::runtime_name

  #-----------------------------------------------------------------------------
  # Installation

  coral::package { $stage_name:
    resources => {
      all => {
        name => $coral::params::runtime_package_names
      }
    },
    defaults => { ensure => $coral::params::package_ensure }
  }
}
