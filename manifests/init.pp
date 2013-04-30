# Class: coral
#
#   General purpose Puppet framework that focuses on extensibility and
#   compatibility between 2.x / 3.x and Hiera / non-Hiera systems.
#
#   This module provides a core framework for building and utilizing other
#   Puppet modules.  It also installs misc packages and utilities that do not
#   fit neatly into specialized bundles and creates and manages custom Facter
#   facts that are loaded through the user environment.  Finally it manages the
#   general security procedures and tools on a server, among the most important
#   functions are creating an extensible firewall rule system and a locked down
#   default.
#
#   TODO: Configuration template engine
#
#
#   Adrian Webb <adrian.webb@coraltech.net>
#   2013-03-30
#
#   Tested platforms:
#    - Ubuntu 12.04
#
#
# Parameters: (see <examples/params.json> for Hiera configurations)
#
#
# Actions:
#
#   - Provides a function and fact based framework for working with modules.
#   - Installs general purpose packages and manages custom facts on the server.
#   - Creates an extensible firewall rule system and locked down default.
#   - Installs the Ruby language
#   - Installs the Ruby Gem package manager
#   - Configures the Ruby environment
#   - Installs and configures other Ruby related resources as needed
#
#
# Requires:
#
#   puppetlabs/apt (on debian/ubuntu)
#   puppetlabs/stdlib
#   puppetlabs/firewall
#   puppetlabs/vcsrepo
#
#
# Sample Usage: (from site.pp) <- Puppet node gateway
#
#   # This assumes the manifest core has been added to the {project dir}/core directory.
#   import "core/*.pp"
#   include coral::default
#
#   #---
#
#   resources { "firewall":
#     purge => true
#   }
#   Firewall {
#     before  => Class['coral::firewall_post_rules'],
#     require => Class['coral::firewall_pre_rules'],
#   }
#   include coral
#   Exec {
#     user => global_param('coral::exec_user'),
#     path => global_param('coral::exec_path'),
#   }
#
class coral (
  $package_ensure           = $coral::params::package_ensure,
  $auto_translate           = $coral::params::auto_translate,
  $fact_env_file            = $coral::params::fact_env_file,
  $ruby_env_file            = $coral::params::ruby_env_file,
  $vagrant_env_file         = $coral::params::vagrant_env_file,
  $env_template_class       = $coral::params::env_template_class,
  $allow_icmp               = $coral::params::allow_icmp,
  $apt_always_apt_update    = $coral::params::apt_always_apt_update,
  $apt_disable_keys         = $coral::params::apt_disable_keys,
  $apt_proxy_host           = $coral::params::apt_proxy_host,
  $apt_proxy_port           = $coral::params::apt_proxy_port,
  $apt_purge_sources_list   = $coral::params::apt_purge_sources_list,
  $apt_purge_sources_list_d = $coral::params::apt_purge_sources_list_d,
  $apt_purge_preferences_d  = $coral::params::apt_purge_preferences_d,
  $gem_names                = $coral::params::gem_names,
  $gem_ensure               = $coral::params::gem_ensure,
  $ruby_set_active_command  = $coral::params::ruby_set_active_command,
  $gem_set_active_command   = $coral::params::gem_set_active_command

) inherits coral::params {

  $base_name = $coral::params::base_name

  coral_initialize($auto_translate)

  include stdlib
  #include firewall

  #-----------------------------------------------------------------------------
  # Installation

  $setup_package_names   = deep_merge($coral::params::setup_package_names, module_array('setup_package_names'))
  $build_package_names   = deep_merge($coral::params::build_package_names, module_array('build_package_names'))
  $common_package_names  = deep_merge($coral::params::common_package_names, module_array('common_package_names'))
  $extra_package_names   = deep_merge($coral::params::extra_package_names, module_array('extra_package_names'))
  $runtime_package_names = deep_merge($coral::params::runtime_package_names, module_array('runtime_package_names'))

  #---

  case $::operatingsystem {
    debian, ubuntu : {
      class { apt:
        always_apt_update    => value($apt_always_apt_update),
        disable_keys         => value($apt_disable_keys),
        proxy_host           => value($apt_proxy_host),
        proxy_port           => value($apt_proxy_port),
        purge_sources_list   => value($apt_purge_sources_list),
        purge_sources_list_d => value($apt_purge_sources_list_d),
        purge_preferences_d  => value($apt_purge_preferences_d),
      }
      Class['apt'] -> Coral::Packages[$base_name]
    }
  }

  class { "coral::setup":
    packages => $setup_package_names,
    ensure   => $package_ensure,
    stage    => 'setup',
  }

  coral::packages { $base_name:
    resources => {
      build_packages  => {
        name => $build_package_names
      },
      common_packages => {
        name    => $common_package_names,
        require => 'build_packages'
      },
      extra_packages  => {
        name    => $extra_package_names,
        require => 'common_packages',
        subscribe => Exec["${base_name}_ruby_active"]
      }
    },
    defaults  => {
      ensure => $package_ensure
    }
  }

  coral::gems { $base_name:
    resources => {
      gems => {
        name => $gem_names
      }
    },
    defaults => { ensure => $gem_ensure },
    subscribe => Exec["${base_name}_gem_active"]
  }

  class { 'coral::runtime':
    packages => $runtime_package_names,
    ensure   => $package_ensure,
    stage    => 'runtime',
  }

  #-----------------------------------------------------------------------------
  # Configuration

  coral::files { $base_name:
    resources => {
      fact_env => {
        path    => $fact_env_file,
        content => render($env_template_class, [ $coral::params::facts, module_hash('facts') ], { name_prefix => 'FACTER' })
      },
      vagrant_env => {
        path    => $vagrant_env_file,
        ensure  => 'absent'
      },
      ruby_env => {
        path    => $ruby_env_file,
        content => render($env_template_class, [ $coral::params::ruby_variables, module_hash('ruby_variables') ]),
        require => 'vagrant_env'
      }
    },
    require => Coral::Packages[$base_name]
  }

  coral::repos { $base_name:
    resources => {}
  }

  # These are added to the Firewall execution flow in site.pp
  #include coral::firewall_pre_rules
  #include coral::firewall_post_rules

  #coral::firewall { $base_name:
  #  resources => {
  #    icmp => {
  #      name   => $allow_icmp ? { true => '101 INPUT allow ICMP', default => '' },
  #      icmp   => '8',
  #      proto  => 'icmp',
  #      action => 'accept'
  #    }
  #  }
  #}

  #-----------------------------------------------------------------------------
  # Actions

  coral::exec { $base_name:
    resources => {
      ruby_active => {
        command     => $ruby_set_active_command,
        refreshonly => true,
        subscribe   => Package["${base_name}_common_packages"]
      },
      gem_active => {
        command     => $gem_set_active_command,
        refreshonly => true,
        subscribe   => Package["${base_name}_extra_packages"]
      }
    }
  }

  #-----------------------------------------------------------------------------
  # Services

  coral::services { $base_name:
    resources => {},
    require   => [ Coral::Gems[$base_name] ]#, Coral::Firewall[$base_name] ]
  }

  coral::cron { $base_name:
    resources => {},
    require   => Coral::Services[$base_name]
  }

  #-----------------------------------------------------------------------------
  # Resources

  coral_resources('coral::make', "${base_name}::make", "${base_name}::make_defaults")
}
