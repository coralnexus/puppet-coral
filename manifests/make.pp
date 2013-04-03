
define coral::make (

  $packages        = [],
  $package_ensure  = 'present',
  $repo_path       = '',
  $repo_provider   = 'git',
  $repo_ensure     = 'latest',
  $repo_source     = undef,
  $repo_revision   = undef,
  $config_options  = '',
  $make_options    = '',
  $install_options = '',
  $user            = $coral::params::exec_user,
  $group           = $coral::params::exec_group,
  $notify          = undef

) {

  $base_name = "coral_make_${name}"

  #-----------------------------------------------------------------------------
  # Installation

  coral::packages { $base_name:
    resources => {
      all => {
        name => $packages
      }
    },
    defaults => { ensure => $package_ensure },
    require  => Coral::Packages['coral']
  }

  #---

  coral::repos { $base_name:
    resources => {
      repo => {
        path     => $repo_path,
        source   => $repo_source,
        revision => $repo_revision,
        notify   => Exec["${base_name}-configure"]
      }
    },
    defaults  => {
      ensure   => $repo_ensure,
      provider => $provider,
      owner    => $user,
      group    => $group
    },
    require => Coral::Packages[$base_name]
  }

  #---

  coral::exec { $base_name:
    resources => {
      configure => {
        command => "./configure ${config_options}"
      },
      make => {
        command   => "make ${make_options}",
        subscribe => "configure"
      },
      make_install => {
        command   => "make install ${install_options}",
        subscribe => "make",
        notify    => $notify
      }
    },
    defaults  => {
      cwd         => $repo_path,
      refreshonly => true
    },
    require => Coral::Repos[$base_name]
  }
}
