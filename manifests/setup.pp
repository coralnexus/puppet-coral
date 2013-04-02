
class coral::setup (

  $packages = [],
  $ensure   = 'present'

) {

  #-----------------------------------------------------------------------------
  # Installation

  coral::packages { 'coral-setup':
    resources => {
      'coral-setup-packages' => {
        name => $packages
      }
    },
    overrides => 'coral::setup_packages',
    defaults  => [ { ensure => $ensure }, 'coral::setup_package_defaults' ]
  }
}
