
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

  $base_name        = "coral-make-${name}"
  $config_base_name = "coral::make::${name}"

  #-----------------------------------------------------------------------------
  # Installation

  coral::packages { $base_name:
    resources => {
      "${base_name}" => {
        name    => $packages,
        ensure  => $package_ensure
      }
    },
    defaults  => "${config_base_name}::package_defaults",
    overrides => "${config_base_name}::packages",
    require   => Coral::Packages['coral']
  }

  #---

  coral::repos { $base_name:
    resources => {
      "${base_name}" => {
        path     => $repo_path,
        source   => $repo_source,
        revision => $repo_revision,
        notify   => Exec["${base_name}-configure"]
      }
    },
    defaults  => [ {
        ensure   => $repo_ensure,
        provider => $provider,
        owner    => $user,
        group    => $group
      },
      "${config_base_name}::repo_defaults"
    ],
    overrides => "${config_base_name}::repos",
    require   => Coral::Packages[$base_name]
  }

  #---

  coral::exec { $base_name:
    resources => {
      "${base_name}-configure" => {
        command => "./configure ${config_options}"
      },
      "${base_name}-make" => {
        command   => "make ${make_options}",
        subscribe => "${base_name}-configure"
      },
      "${base_name}-make-install" => {
        command   => "make install ${install_options}",
        subscribe => "${base_name}-make",
        notify    => $notify
      }
    },
    defaults  => [ {
        cwd         => $repo_path,
        refreshonly => true
      },
      "${config_base_name}::exec_defaults"
    ],
    overrides => "${config_base_name}::exec",
    require   => Coral::Repos[$base_name]
  }
}
