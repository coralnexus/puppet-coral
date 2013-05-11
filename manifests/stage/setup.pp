
class coral::stage::setup {

  $base_name = $coral::params::base_name
  $stage_name = $coral::params::setup_name

  #-----------------------------------------------------------------------------
  # Installation

  coral::package { $stage_name:
    resources => {
      all => {
        name => $coral::params::setup_package_names
      }
    },
    defaults => { ensure => $coral::params::package_ensure }
  }
}
