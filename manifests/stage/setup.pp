
class corl::stage::setup {

  $base_name = $corl::params::base_name
  $stage_name = $corl::params::setup_name

  #-----------------------------------------------------------------------------
  # Installation

  corl::package { $stage_name:
    resources => {
      all => {
        name => $corl::params::setup_package_names
      }
    },
    defaults => { ensure => $corl::params::package_ensure }
  }
}
