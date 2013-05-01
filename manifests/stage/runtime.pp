
class coral::stage::runtime {
  $base_name = $coral::params::base_name

  #-----------------------------------------------------------------------------
  # Installation

  coral::package { "${base_name}_runtime":
    resources => {
      all => {
        name => $coral::params::runtime_package_names
      }
    },
    defaults => { ensure => $coral::params::package_ensure }
  }
}
