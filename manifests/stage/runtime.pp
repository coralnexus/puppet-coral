
class corl::stage::runtime {

  $base_name = $corl::params::base_name
  $stage_name = $corl::params::runtime_name

  #-----------------------------------------------------------------------------
  # Installation

  corl::package { $stage_name:
    resources => {
      all => {
        name => $corl::params::runtime_package_names
      }
    },
    defaults => { ensure => $corl::params::package_ensure }
  }
}
