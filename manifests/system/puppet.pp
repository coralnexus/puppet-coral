
class coral::system::puppet {
  $base_name = $coral::params::base_name
  $ruby_name = $coral::params::ruby_name
  $system_name = $coral::params::puppet_name

  #-----------------------------------------------------------------------------
  # Installation

  case $::operatingsystem {
    debian, ubuntu : {
      apt::source { $system_name:
        location   => $coral::params::puppet_apt_location,
        repos      => $coral::params::puppet_apt_repos,
        key        => $coral::params::puppet_apt_key,
        key_server => $coral::params::puppet_apt_key_server
      }
      Class['apt'] -> Coral::Package[$system_name]
    }
  }

  #---

  coral::package { $system_name:
    resources => {
      core_packages => {
        name => $coral::params::puppet_package_names
      },
      extra_packages  => {
        name    => $coral::params::puppet_extra_package_names,
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

  $report_emails = $coral::params::puppet_report_emails

  $hiera_merge_type = $coral::params::hiera_merge_type
  $hiera_hierarchy = $coral::params::hiera_hierarchy
  $hiera_backends = $coral::params::hiera_backends

  coral::file { $system_name:
    resources => {
      init_conf => {
        path    => $coral::params::puppet_init_config_file,
        content => render($coral::params::env_template, [ $coral::params::puppet_daemon_env, {
          'START' => $coral::params::puppet_service_ensure ? { 'running' => 'yes', default => 'no' },
        }])
      },
      conf => {
        path    => $coral::params::puppet_config_file,
        content => render($coral::params::puppet_config_template, $coral::params::puppet_config)
      },
      tag_map => {
        path    => $coral::params::puppet_tagmail_config_file,
        content => template($coral::params::puppet_tagmail_template)
      },
      report_dir => {
        path => $coral::params::puppet_report_dir,
        ensure => 'directory'
      },
      hiera_config => {
        path    => $coral::params::hiera_config,
        content => template($coral::params::hiera_config_template),
      },
      hiera_puppet_config => {
        path    => $coral::params::puppet_hiera_config_file,
        content => template($coral::params::puppet_hiera_config_template),
      }
    },
    defaults => { notify => Service["${system_name}_service"] }
  }

  #-----------------------------------------------------------------------------
  # Services

  coral::service { $system_name:
    resources => {
      service => {
        name   => $coral::params::puppet_service_name,
        ensure => $coral::params::puppet_service_ensure,
      }
    },
    require => [ Coral::Service[$base_name], Coral::Package[$system_name] ]
  }

  #---

  coral::cron { $system_name:
    resources => {
      refresh => {
        ensure      => $coral::params::puppet_cron_ensure,
        environment => $coral::params::puppet_update_environment,
        command     => $coral::params::puppet_update_command,
        user        => $coral::params::puppet_cron_user,
        minute      => $coral::params::puppet_update_interval
      }
    },
    require => Coral::Service[$system_name]
  }
}
