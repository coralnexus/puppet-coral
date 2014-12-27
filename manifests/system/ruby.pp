
class corl::system::ruby inherits corl::params::ruby {

  $base_name   = $corl::params::base_name
  $system_name = $corl::params::ruby_name

  #-----------------------------------------------------------------------------
  # Installation

  corl::gem { $system_name:
    resources => {
      gems => {
        name => $corl::params::ruby::gem_names
      }
    },
    defaults => { ensure => $corl::params::ruby::gem_ensure }
  }

  #-----------------------------------------------------------------------------
  # Configuration

  corl::file { $system_name:
    resources => {
      env => {
        path    => $corl::params::ruby::env_file,
        content => render($corl::params::env_template, $corl::params::ruby::variables)
      },
      root_gemrc => {
        path    => $corl::params::ruby::root_gemrc_file,
        content => $corl::params::ruby::root_gemrc
      }
    }
  }

  #-----------------------------------------------------------------------------
  # Actions
}
