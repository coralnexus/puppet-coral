
class corl::params::puppet inherits corl::default {

  $apt_location   = module_param('puppet_apt_location', 'http://apt.puppetlabs.com')
  $apt_repos      = module_param('puppet_apt_repos', 'main dependencies')
  $apt_key        = module_param('puppet_apt_key', '4BD6EC30')
  $apt_key_server = module_param('puppet_apt_key_server', 'pgp.mit.edu')

  $package_name       = module_param('puppet_package_name')
  $package_ensure     = module_param('puppet_package_ensure')

  $extra_package_names = module_array('puppet_extra_package_names')

  $init_config_file = module_param('puppet_init_config_file')
  $daemon_env       = module_hash('puppet_daemon_env', {
    'DAEMON_OPTS' => ''
  })

  $config_template = module_param('puppet_config_template', 'puppetconf')

  # For available options, see: http://docs.puppetlabs.com/references/3.1.latest/configuration.html
  $config = module_hash('puppet_config', {
    main => {
      data_binding_terminus => 'corl',
      confdir               => '/etc/puppet',
      config                => '$confdir/puppet.conf',
      logdir                => '/var/log/puppet',
      vardir                => '/var/lib/puppet',
      ssldir                => '$vardir/ssl',
      rundir                => '/var/run/puppet',
      factpath              => '$vardir/lib/facter',
      report                => true,
      reportdir             => '$logdir/reports',
      reports               => 'store',
      hiera_config          => '$confdir/hiera.yaml',
      tagmap                => '$confdir/tagmail.conf',
      ordering              => 'title-hash'
    }
  })
  $manifest                 = interpolate($config['main']['manifest'], $config['main'])
  $config_file              = interpolate($config['main']['config'], $config['main'])
  $hiera_puppet_config_file = interpolate($config['main']['hiera_config'], $config['main'])
  $tagmail_config_file      = interpolate($config['main']['tagmap'], $config['main'])
  $report_dir               = interpolate($config['main']['reportdir'], $config['main'])

  $tagmail_template = module_param('puppet_tagmail_template', 'corl/tagmail.conf.erb')
  $report_emails    = module_hash('puppet_report_emails')

  $hiera_config_file            = module_param('hiera_config_file', '/etc/hiera.yaml')
  $hiera_config_template        = module_param('hiera_config_template', 'corl/hiera.yaml.erb')
  $hiera_puppet_config_template = module_param('hiera_puppet_config_template', 'corl/hiera.puppet.yaml.erb')

  $hiera_backends = module_array('hiera_backends', [
    module_hash('hiera_json_backend', {
      'type' => 'json',
      'datadir' => '/var/lib/hiera',
    }),
    module_hash('hiera_yaml_backend', {
      'type' => 'yaml',
      'datadir' => '/var/lib/hiera',
    })
  ])

  $hiera_hierarchy  = module_array('hiera_hierarchy', 'common')
  $hiera_merge_type = module_param('hiera_merge_type', 'deeper')

  $service_name    = module_param('puppet_service_name', 'puppet')
  $service_ensure  = module_param('puppet_service_ensure', 'stopped')
}
