
class coral::runtime (

  $packages = [],
  $ensure   = 'present',

) {

  #-----------------------------------------------------------------------------
  # Installation

  coral::packages { coral_runtime:
    resources => {
      all => {
        name => $packages
      }
    },
    defaults => { ensure => $ensure }
  }
}
