class corl::system::puppet inherits corl::params::puppet {

  $base_name   = $corl::params::base_name
  $ruby_name   = $corl::params::ruby_name
  $system_name = $corl::params::puppet_name

  #-----------------------------------------------------------------------------
  # Installation

  case $::operatingsystem {
    debian, ubuntu : {
      apt::source { $system_name:
        location   => $corl::params::puppet::apt_location,
        repos      => $corl::params::puppet::apt_repos,
        key        => $corl::params::puppet::apt_key,
        key_server => $corl::params::puppet::apt_key_server
      }
      Class['apt'] -> Corl::Package[$system_name]
    }
  }

  #---

  corl::package { $system_name:
    resources => {
      core_package => {
        name   => $corl::params::puppet::package_name,
        ensure => $corl::params::puppet::package_ensure
      },
      extra_packages  => {
        name    => $corl::params::puppet::extra_package_names,
        require => 'core_package'
      }
    },
    defaults  => {
      ensure => $corl::params::package_ensure
    },
    require => [ Corl::Gem[$ruby_name], Corl::File[$system_name] ]
  }

  #-----------------------------------------------------------------------------
  # Configuration

  $report_emails = $corl::params::puppet::report_emails

  $hiera_merge_type = $corl::params::puppet::hiera_merge_type
  $hiera_hierarchy  = $corl::params::puppet::hiera_hierarchy
  $hiera_backends   = $corl::params::puppet::hiera_backends

  corl::file { $system_name:
    resources => {
      init_conf => {
        path    => $corl::params::puppet::init_config_file,
        content => render($corl::params::env_template, [ $corl::params::puppet::daemon_env, {
          'START' => $corl::params::puppet::service_ensure ? { 'running' => 'yes', default => 'no' },
        }])
      },
      conf => {
        path    => $corl::params::puppet::config_file,
        content => render($corl::params::puppet::config_template, $corl::params::puppet::config)
      },
      tag_map => {
        path    => $corl::params::puppet::tagmail_config_file,
        content => template($corl::params::puppet::tagmail_template)
      },
      report_dir => {
        path => $corl::params::puppet::report_dir,
        ensure => 'directory'
      },
      hiera_config => {
        path    => $corl::params::puppet::hiera_config_file,
        content => template($corl::params::puppet::hiera_config_template),
      },
      hiera_puppet_config => {
        path    => $corl::params::puppet::hiera_puppet_config_file,
        content => template($corl::params::puppet::hiera_puppet_config_template),
      },
      var_dir => {
        path   => $corl::params::puppet::config['main']['vardir'],
        ensure => directory,
        owner  => $corl::params::puppet_user,
        group  => $corl::params::puppet_group,
        mode   => '775'
      },
      log_dir => {
        path => $corl::params::puppet::config['main']['logdir'],
        ensure => directory,
        owner  => $corl::params::puppet_user,
        group  => $corl::params::puppet_group,
        mode   => '775'
      }
    },
    defaults => { notify => Service["${system_name}_service"] }
  }

  #-----------------------------------------------------------------------------
  # Services

  corl::service { $system_name:
    resources => {
      service => {
        name   => $corl::params::puppet::service_name,
        ensure => $corl::params::puppet::service_ensure,
      }
    },
    require => [ Corl::Service[$base_name], Corl::Package[$system_name] ]
  }
}
