
define global::make (

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
  $user            = $global::params::exec_user,
  $group           = $global::params::exec_group,
  $notify          = undef

) {

  $base_name        = "global-make-${name}"
  $config_base_name = "global::make::${name}"

  #-----------------------------------------------------------------------------
  # Installation

  global::packages { $base_name:
    resources => {
      "${base_name}" => {
        name    => $packages,
        ensure  => $package_ensure
      }
    },
    overrides => "${config_base_name}::packages",
    require   => Global::Packages['global']
  }

  #---

  global::repos { $base_name:
    resources => {
      "${base_name}" => {
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
    overrides => "${config_base_name}::repos",
    require   => Global::Packages[$base_name]
  }

  #---

  global::exec { $base_name:
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
    defaults  => {
      cwd         => $repo_path,
      refreshonly => true
    },
    overrides => "${config_base_name}::exec",
    require   => Global::Repos[$base_name]
  }
}
