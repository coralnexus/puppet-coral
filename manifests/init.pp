# Class: global
#
#   This module provides a core framework for building and utilizing other
#   Puppet modules.  It also installs misc packages and utilities that do not
#   fit neatly into specialized bundles and creates and manages custom Facter
#   facts that are loaded through the user environment.
#
#   This module manages the general security procedures and tools on a server.
#   Among the most important functions are creating an extensible firewall rule
#   system and a locked down default.
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
#   resources { "firewall":
#     purge => true
#   }
#   Firewall {
#     before  => Class['global::firewall_post_rules'],
#     require => Class['global::firewall_pre_rules'],
#   }
#   class { 'global':
#     facts => global_hash('global::facts')
#   }
#   Exec {
#     user => global_param('global::exec_user'),
#     path => global_param('global::exec_path'),
#   }
#
class global (

  $setup_packages           = $global::params::setup_packages,
  $build_packages           = $global::params::build_packages,
  $common_packages          = $global::params::common_packages,
  $runtime_packages         = $global::params::runtime_packages,
  $package_ensure           = $global::params::runtime_ensure,
  $fact_environment         = $global::params::fact_environment,
  $facts_template           = $global::params::facts_template,
  $facts                    = $global::params::facts,
  $allow_icmp               = $global::params::allow_icmp,
  $apt_always_apt_update    = $global::params::apt_always_apt_update,
  $apt_disable_keys         = $global::params::apt_disable_keys,
  $apt_proxy_host           = $global::params::apt_proxy_host,
  $apt_proxy_port           = $global::params::apt_proxy_port,
  $apt_purge_sources_list   = $global::params::apt_purge_sources_list,
  $apt_purge_sources_list_d = $global::params::apt_purge_sources_list_d,
  $apt_purge_preferences_d  = $global::params::apt_purge_preferences_d

) inherits global::params {

  include stdlib
  include firewall

  #-----------------------------------------------------------------------------
  # Installation

  case $::operatingsystem {
    debian, ubuntu: {
      class { 'apt':
        always_apt_update    => $apt_always_apt_update,
        disable_keys         => $apt_disable_keys,
        proxy_host           => $apt_proxy_host,
        proxy_port           => $apt_proxy_port,
        purge_sources_list   => $apt_purge_sources_list,
        purge_sources_list_d => $apt_purge_sources_list_d,
        purge_preferences_d  => $apt_purge_preferences_d,
      }
    }
  }

  class { 'global::setup':
    packages => $setup_packages,
    ensure   => $package_ensure,
    stage    => 'setup',
  }

  global::packages { 'global':
    resources => {
      'build-packages' => {
        name => $build_packages
      },
      'common-packages' => {
        name    => $common_packages,
        require => 'build-packages'
      }
    },
    overrides => 'global::main_packages',
    defaults  => { ensure => $package_ensure }
  }

  if (defined(Class['apt'])) {
    Class['apt'] -> Global::Packages['global']
  }

  class { 'global::runtime':
    packages => $runtime_packages,
    ensure   => $package_ensure,
    stage    => 'runtime',
  }

  #-----------------------------------------------------------------------------
  # Configuration

  global::files { 'global':
    resources => {
      'fact-environment' => {
        path    => $fact_environment,
        content => template($facts_template)
      }
    },
    require => Global::Packages['global']
  }

  # These are added to the Firewall execution flow in site.pp
  include global::firewall_pre_rules
  include global::firewall_post_rules

  global::firewall { 'global':
    resources => {
      'icmp' => {
        name   => $allow_icmp ? { true => '101 INPUT allow ICMP', default => '' },
        icmp   => '8',
        proto  => 'icmp',
        action => 'accept'
      }
    }
  }

  #-----------------------------------------------------------------------------
  # Dynamic resources

  global_resources('global::make')

  #---

  global_resources('@vcsrepo', 'global::repos', { tag => global })
  Global::Files['global'] -> Vcsrepo<| tag == global |>
}
