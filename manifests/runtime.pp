
class global::runtime (

  $packages = [],
  $ensure   = 'present',

) {

  #-----------------------------------------------------------------------------
  # Installation

  global::packages { 'global-runtime':
    resources => {
      'global-runtime-packages' => {
        name => $packages
      }
    },
    overrides => 'global::runtime_packages',
    defaults  => { ensure => $ensure }
  }
}
