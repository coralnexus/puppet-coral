
class coral::runtime (

  $packages = [],
  $ensure   = 'present',

) {

  #-----------------------------------------------------------------------------
  # Installation

  coral::packages { 'coral-runtime':
    resources => {
      'coral-runtime-packages' => {
        name => $packages
      }
    },
    overrides => 'coral::runtime_packages',
    defaults  => [ { ensure => $ensure }, 'coral::runtime_package_defaults' ]
  }
}
