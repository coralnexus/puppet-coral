
class coral::params::puppet inherits coral::default {

  $apt_location   = module_param('puppet_apt_location', 'http://apt.puppetlabs.com')
  $apt_repos      = module_param('puppet_apt_repos', 'main')
  $apt_key        = module_param('puppet_apt_key', '4BD6EC30')
  $apt_key_server = module_param('puppet_apt_key_server', 'pgp.mit.edu')

  $package_names       = module_array('puppet_package_names')
  $extra_package_names = module_array('puppet_extra_package_names')

  $bin = module_param('puppet_bin')

  $init_config_file = module_param('puppet_init_config_file')
  $daemon_env       = module_hash('puppet_daemon_env', {
    'DAEMON_OPTS' => ''
  })

  $config_template = module_param('puppet_config_template', 'PuppetConf')

  # For available options, see: http://docs.puppetlabs.com/references/3.1.latest/configuration.html
  $config = module_hash('puppet_config', {
    main => {
      data_binding_terminus => 'coral',
      confdir               => '/etc/puppet',
      config                => '$confdir/puppet.conf',
      logdir                => '/var/log/puppet',
      vardir                => '/var/lib/puppet',
      ssldir                => '$vardir/ssl',
      rundir                => '/var/run/puppet',
      factpath              => '$vardir/lib/facter',
      templatedir           => '$confdir/templates',
      manifestdir           => '$confdir/manifests',
      manifest              => '$manifestdir/site.pp',
      prerun_command        => '$confdir/etckeeper-commit-pre',
      postrun_command       => '$confdir/etckeeper-commit-post',
      modulepath            => '$confdir/modules',
      report                => true,
      reportdir             => '$logdir/reports',
      reports               => 'store',
      hiera_config          => '$confdir/hiera.yaml',
      tagmap                => '$confdir/tagmail.conf'
    }
  })
  $manifest                 = interpolate($config['main']['manifest'], $config['main'])
  $config_file              = interpolate($config['main']['config'], $config['main'])
  $hiera_puppet_config_file = interpolate($config['main']['hiera_config'], $config['main'])
  $tagmail_config_file      = interpolate($config['main']['tagmap'], $config['main'])
  $report_dir               = interpolate($config['main']['reportdir'], $config['main'])

  $tagmail_template = module_param('puppet_tagmail_template', 'coral/tagmail.conf.erb')
  $report_emails    = module_hash('puppet_report_emails')

  $hiera_config_file            = module_param('hiera_config_file', '/etc/hiera.yaml')
  $hiera_config_template        = module_param('hiera_config_template', 'coral/hiera.yaml.erb')
  $hiera_puppet_config_template = module_param('hiera_puppet_config_template', 'coral/hiera.puppet.yaml.erb')

  $hiera_backends = module_array('hiera_backends', [
    module_hash('hiera_json_backend', {
      'type' => 'json',
      'datadir' => '/var/lib/hiera',
    })
  ])

  $hiera_hierarchy  = module_array('hiera_hierarchy', 'common')
  $hiera_merge_type = module_param('hiera_merge_type', 'deeper')

  $service_name    = module_param('puppet_service_name', 'puppet')
  $service_ensure  = module_param('puppet_service_ensure', 'stopped')

  $cron_ensure        = module_param('puppet_cron_ensure', 'absent')
  $cron_user          = module_param('puppet_cron_user', 'root')
  $update_interval    = module_param('puppet_update_interval', '*/30')
  $update_environment = module_param('puppet_update_environment', 'PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin')
  $update_command     = module_param('puppet_update_command', "${bin} apply '${manifest}'")
}
