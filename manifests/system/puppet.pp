
class coral::system::puppet inherits coral::params::puppet {

  $base_name   = $coral::params::base_name
  $ruby_name   = $coral::params::ruby_name
  $system_name = $coral::params::puppet_name

  #-----------------------------------------------------------------------------
  # Installation

  case $::operatingsystem {
    debian, ubuntu : {
      apt::source { $system_name:
        location   => $coral::params::puppet::apt_location,
        repos      => $coral::params::puppet::apt_repos,
        key        => $coral::params::puppet::apt_key,
        key_server => $coral::params::puppet::apt_key_server
      }
      Class['apt'] -> Coral::Package[$system_name]
    }
  }

  #---

  coral::package { $system_name:
    resources => {
      core_packages => {
        name => $coral::params::puppet::package_names
      },
      extra_packages  => {
        name    => $coral::params::puppet::extra_package_names,
        require => 'core_packages'
      }
    },
    defaults  => {
      ensure => $coral::params::package_ensure
    },
    require => Coral::Gem[$ruby_name]
  }

  #-----------------------------------------------------------------------------
  # Configuration

  $report_emails = $coral::params::puppet::report_emails

  $hiera_merge_type = $coral::params::puppet::hiera_merge_type
  $hiera_hierarchy  = $coral::params::puppet::hiera_hierarchy
  $hiera_backends   = $coral::params::puppet::hiera_backends

  coral::file { $system_name:
    resources => {
      init_conf => {
        path    => $coral::params::puppet::init_config_file,
        content => render($coral::params::env_template, [ $coral::params::puppet::daemon_env, {
          'START' => $coral::params::puppet::service_ensure ? { 'running' => 'yes', default => 'no' },
        }])
      },
      conf => {
        path    => $coral::params::puppet::config_file,
        content => render($coral::params::puppet::config_template, $coral::params::puppet::config)
      },
      tag_map => {
        path    => $coral::params::puppet::tagmail_config_file,
        content => template($coral::params::puppet::tagmail_template)
      },
      report_dir => {
        path => $coral::params::puppet::report_dir,
        ensure => 'directory'
      },
      hiera_config => {
        path    => $coral::params::puppet::hiera_config_file,
        content => template($coral::params::puppet::hiera_config_template),
      },
      hiera_puppet_config => {
        path    => $coral::params::puppet::hiera_puppet_config_file,
        content => template($coral::params::puppet::hiera_puppet_config_template),
      }
    },
    defaults => { notify => Service["${system_name}_service"] }
  }

  #-----------------------------------------------------------------------------
  # Services

  coral::service { $system_name:
    resources => {
      service => {
        name   => $coral::params::puppet::service_name,
        ensure => $coral::params::puppet::service_ensure,
      }
    },
    require => [ Coral::Service[$base_name], Coral::Package[$system_name] ]
  }

  #---

  coral::cron { $system_name:
    resources => {
      refresh => {
        ensure      => $coral::params::puppet::cron_ensure,
        environment => $coral::params::puppet::update_environment,
        command     => $coral::params::puppet::update_command,
        user        => $coral::params::puppet::cron_user,
        minute      => $coral::params::puppet::update_interval
      }
    },
    require => Coral::Service[$system_name]
  }
}
