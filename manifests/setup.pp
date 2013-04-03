
class coral::setup (

  $packages = [],
  $ensure   = 'present'

) {

  #-----------------------------------------------------------------------------
  # Installation

  coral::packages { coral_init:
    resources => {
      all => {
        name => $packages
      }
    },
    defaults => { ensure => $ensure }
  }
}
