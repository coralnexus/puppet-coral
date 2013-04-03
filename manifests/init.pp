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
  $fact_environment         = $coral::params::fact_environment,
  $facts_template           = $coral::params::facts_template,
  $allow_icmp               = $coral::params::allow_icmp,
  $apt_always_apt_update    = $coral::params::apt_always_apt_update,
  $apt_disable_keys         = $coral::params::apt_disable_keys,
  $apt_proxy_host           = $coral::params::apt_proxy_host,
  $apt_proxy_port           = $coral::params::apt_proxy_port,
  $apt_purge_sources_list   = $coral::params::apt_purge_sources_list,
  $apt_purge_sources_list_d = $coral::params::apt_purge_sources_list_d,
  $apt_purge_preferences_d  = $coral::params::apt_purge_preferences_d

) inherits coral::params {

  if is_true($auto_translate) {
    coral_auto_translate()
  }

  include stdlib
  include firewall

  $base_name = 'coral'

  #-----------------------------------------------------------------------------
  # Installation

  $setup_package_names = normalize(
    $coral::params::setup_package_names,
    module_array('setup_package_names')
  )
  $build_package_names = normalize(
    $coral::params::build_package_names,
    module_array('build_package_names')
  )
  $common_package_names = normalize(
    $coral::params::common_package_names,
    module_array('common_package_names')
  )
  $extra_package_names = normalize(
    $coral::params::extra_package_names,
    module_array('extra_package_names')
  )
  $runtime_package_names = normalize(
    $coral::params::runtime_package_names,
    module_array('runtime_package_names')
  )

  #---

  case $::operatingsystem {
    debian, ubuntu: {
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
      build_packages => {
        name => $build_package_names
      },
      common_packages => {
        name    => $common_package_names,
        require => 'build_packages'
      },
      extra_packages => {
        name    => $extra_package_names,
        require => 'common_packages'
      }
    },
    defaults => { ensure => $package_ensure }
  }

  class { 'coral::runtime':
    packages => $runtime_package_names,
    ensure   => $package_ensure,
    stage    => 'runtime',
  }

  #-----------------------------------------------------------------------------
  # Configuration

  $facts = render(normalize($coral::params::facts, module_hash('facts')))

  #---

  coral::files { $base_name:
    resources => {
      fact_environment => {
        path    => $fact_environment,
        content => template($facts_template)
      }
    },
    require => Coral::Packages[$base_name]
  }

  coral::repos { $base_name:
    resources => {}
  }

  # These are added to the Firewall execution flow in site.pp
  include coral::firewall_pre_rules
  include coral::firewall_post_rules

  coral::firewall { $base_name:
    resources => {
      icmp => {
        name   => $allow_icmp ? { true => '101 INPUT allow ICMP', default => '' },
        icmp   => '8',
        proto  => 'icmp',
        action => 'accept'
      }
    }
  }

  #-----------------------------------------------------------------------------
  # Actions

  coral::exec { $base_name:
    resources => {}
  }

  #-----------------------------------------------------------------------------
  # Services

  coral::services { $base_name:
    resources => {},
    require   => Coral::Repos[$base_name]
  }

  coral::cron { $base_name:
    resources => {},
    require   => Coral::Services[$base_name]
  }

  #-----------------------------------------------------------------------------
  # Resources

  coral_resources('coral::make', "${base_name}::make", "${base_name}::make_defaults")
}
