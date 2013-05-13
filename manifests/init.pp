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
#   import "*.pp"
#   import "default/*.pp"
#   include global::default
#
#   #---
#
#   resources { "firewall":
#     purge => true
#   }
#   Firewall {
#     before  => Class['coral::firewall::post_rules'],
#     require => Class['coral::firewall::pre_rules'],
#   }
#
#   include coral
#   include coral::firewall::pre_rules
#   include coral::firewall::post_rules
#
#   Exec {
#     user => $coral::params::exec_user,
#     path => $coral::params::exec_path
#   }
#
class coral inherits coral::params {

  $base_name = $coral::params::base_name

  include stdlib
  include firewall

  #---

  # Core systems to get a fully functional Puppet server with security permissions.

  if ($coral::params::manage_ruby) {
    include coral::system::ruby
  }
  if ($coral::params::manage_puppet) {
    include coral::system::puppet
  }
  if ($coral::params::manage_ssh) {
    include coral::system::ssh
  }
  if ($coral::params::manage_sudo) {
    include coral::system::sudo
  }

  #-----------------------------------------------------------------------------
  # Installation

  case $::operatingsystem {
    debian, ubuntu : {
      class { 'apt':
        always_apt_update    => $coral::params::apt_always_apt_update,
        disable_keys         => $coral::params::apt_disable_keys,
        proxy_host           => $coral::params::apt_proxy_host,
        proxy_port           => $coral::params::apt_proxy_port,
        purge_sources_list   => $coral::params::apt_purge_sources_list,
        purge_sources_list_d => $coral::params::apt_purge_sources_list_d,
        purge_preferences_d  => $coral::params::apt_purge_preferences_d,
      }
      Class['apt'] -> Coral::Package[$base_name]
    }
  }

  #---

  class { 'coral::stage::setup': stage => 'setup' }
  class { 'coral::stage::runtime': stage => 'runtime' }

  #---

  coral::package { $base_name:
    resources => {
      build_packages  => {
        name => $coral::params::build_package_names
      },
      common_packages => {
        name    => $coral::params::common_package_names,
        require => 'build_packages'
      },
      extra_packages  => {
        name    => $coral::params::extra_package_names,
        require => 'common_packages'
      }
    },
    defaults  => {
      ensure => $coral::params::package_ensure
    }
  }

  #-----------------------------------------------------------------------------
  # Configuration

  coral::file { $base_name:
    resources => {
      env => {
        path    => $coral::params::fact_env_file,
        content => render($coral::params::env_template, $coral::params::facts, { name_prefix => 'FACTER' })
      },
      vagrant_env => {
        path    => $coral::params::vagrant_env_file,
        ensure  => 'absent'
      }
    }
  }

  #---

  coral::vcsrepo { $base_name: }

  #---

  include coral::firewall::icmp
  coral::firewall { $base_name: }

  #-----------------------------------------------------------------------------
  # Actions

  coral::exec { $base_name: }

  #-----------------------------------------------------------------------------
  # Services

  coral::service { $base_name: require => Coral::Firewall[$base_name] }
  coral::cron { $base_name: require => Coral::Service[$base_name] }

  #-----------------------------------------------------------------------------
  # Resources

  coral_resources('coral::make', "${base_name}::make", "${base_name}::make_defaults")
}
