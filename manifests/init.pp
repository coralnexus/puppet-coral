# Class: corl
#
#   Manages the CORL system.  (see: http://coralnexus.com/projects/corl)
#
#
#   Adrian Webb <adrian.webb@coralnexus.com>
#   2014-03-13
#
#   Tested platforms:
#    - Ubuntu 12.04
#
#
# Parameters: (see <examples/params.json> for Hiera configurations)
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
#     before  => Class['corl::firewall::post_rules'],
#     require => Class['corl::firewall::pre_rules'],
#   }
#
#   include corl
#   include corl::firewall::pre_rules
#   include corl::firewall::post_rules
#
#   Exec {
#     user => $corl::params::exec_user,
#     path => $corl::params::exec_path
#   }
#
class corl inherits corl::params {

  $base_name = $corl::params::base_name

  #---

  include stdlib
  include firewall

  #---

  module_options('log', {
    config_log   => $corl::params::property_path,
    config_store => $corl::params::property_store
  })
  include corl::system::log

  # Core systems to get a fully functional Puppet server with security permissions.

  if ($corl::params::manage_ruby) {
    include corl::system::ruby
  }
  if ($corl::params::manage_puppet) {
    include corl::system::puppet
  }
  if ($corl::params::manage_ssh) {
    include corl::system::ssh
  }
  if ($corl::params::manage_sudo) {
    include corl::system::sudo
  }

  #-----------------------------------------------------------------------------
  # Installation

  case $::operatingsystem {
    debian, ubuntu : {
      class { 'apt':
        always_apt_update    => $corl::params::apt_always_apt_update,
        disable_keys         => $corl::params::apt_disable_keys,
        proxy_host           => $corl::params::apt_proxy_host,
        proxy_port           => $corl::params::apt_proxy_port,
        purge_sources_list   => $corl::params::apt_purge_sources_list,
        purge_sources_list_d => $corl::params::apt_purge_sources_list_d,
        purge_preferences_d  => $corl::params::apt_purge_preferences_d,
      }
      Class['apt'] -> Corl::Package[$base_name]
    }
  }

  #--- 

  class { 'corl::stage::setup': stage => 'setup' }
  class { 'corl::stage::runtime': stage => 'runtime' }

  #---

  corl::package { $base_name:
    resources => {
      build_packages  => {
        name => $corl::params::build_package_names
      },
      common_packages => {
        name    => $corl::params::common_package_names,
        require => 'build_packages'
      },
      extra_packages  => {
        name    => $corl::params::extra_package_names,
        require => 'common_packages'
      }
    },
    defaults  => {
      ensure => $corl::params::package_ensure
    }
  }

  #-----------------------------------------------------------------------------
  # Configuration

  corl::file { $base_name:
    resources => {
      vagrant_env => {
        path    => $corl::params::vagrant_env_file,
        ensure  => 'absent'
      }
    }
  }

  #---

  corl::vcsrepo { $base_name: }

  #---

  include corl::firewall::icmp
  corl::firewall { $base_name: }

  #-----------------------------------------------------------------------------
  # Actions

  corl::exec { $base_name: }

  #-----------------------------------------------------------------------------
  # Services

  corl::service { $base_name: require => Corl::Firewall[$base_name] }
  corl::cron { $base_name: require => Corl::Service[$base_name] }

  #-----------------------------------------------------------------------------
  # Resources

  corl_resources('corl::make', "${base_name}::make", "${base_name}::make_defaults")
}
