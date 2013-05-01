
class coral::setup {
  $base_name = $coral::params::base_name

  #-----------------------------------------------------------------------------
  # Installation

  coral::package { "${base_name}_setup":
    resources => {
      all => {
        name => $coral::params::setup_package_names
      }
    },
    defaults => { ensure => $coral::params::package_ensure }
  }
}
