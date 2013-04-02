
class global::setup (

  $packages = [],
  $ensure   = 'present'

) {

  #-----------------------------------------------------------------------------
  # Installation

  global::packages { 'global-setup':
    resources => {
      'global-setup-packages' => {
        name => $packages
      }
    },
    overrides => 'global::setup_packages',
    defaults  => { ensure => $ensure }
  }
}
