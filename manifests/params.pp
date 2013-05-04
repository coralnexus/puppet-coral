
class coral::params {
  coral_initialize()

  $time = time()

  # Names
  $base_name = 'coral'

  $ruby_name = "${base_name}_ruby"
  $puppet_name = "${base_name}_puppet"

  $setup_name = "${base_name}_setup"
  $runtime_name = "${base_name}_runtime"
  $deploy_name = "${base_name}_deploy"

  # Common
  $generate_properties = module_param('generate_properties', true)

  $package_ensure = module_param('package_ensure', 'present')

  $facts = module_hash('facts')

  $firewall_icmp_name = module_param('firewall_icmp_name', '101 INPUT allow ICMP')
  $firewall_loopback_input_name = module_param('firewall_loopback_input_name', '001 INPUT allow loopbacks')
  $firewall_loopback_output_name = module_param('firewall_loopback_output_name', '002 OUTPUT allow loopback')
  $firewall_related_established_name = module_param('firewall_related_established_name', '050 Allow related and established')
  $firewall_all_outbound_name = module_param('firewall_all_outbound_name', '090 OUTPUT allow all outbound')
  $firewall_log_rejected_name = module_param('firewall_log_rejected_name', '950 INPUT log all rejected')
  $firewall_reject_all_name = module_param('firewall_reject_all_name', '999 Reject all')

  $json_template = module_param('json_template', 'JSON')
  $env_template = module_param('env_template', 'Environment')

  # Ruby
  $gem_names = module_array('gem_names', ['coral', 'deep_merge', 'puppet-module', 'hiera-json'])
  $gem_ensure = module_param('gem_ensure', 'latest')

  # Puppet
  $puppet_service_ensure = module_param('puppet_service_ensure', 'stopped')
  $puppet_report_emails = module_hash('puppet_report_emails')
  $puppet_cron_ensure = module_param('puppet_cron_ensure', 'absent')
  $puppet_cron_user = module_param('puppet_cron_user', 'root')
  $puppet_update_interval = module_param('puppet_update_interval', '*/30')

  $hiera_hierarchy = module_array('hiera_hierarchy', [ '%{::hostname}', '%{::environment}', 'common' ])
  $hiera_merge_type = module_param('hiera_merge_type', 'deeper')

  #---

  case $::operatingsystem {
    debian, ubuntu : {
      # OS Common
      $property_dir = module_param('property_dir', '/var/log/coral')
      $property_dir_mode = module_param('property_dir_mode', '0744')
      $property_file = module_param('property_file', "config.${::operatingsystem}.${time}.json")
      $property_file_mode = module_param('property_file_mode', '0744')
      $property_owner = module_param('property_owner', 'root')
      $property_group = module_param('property_group', 'admin')

      $exec_path = module_array('exec_path', ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'])
      $exec_user = module_param('exec_user', 'root')
      $exec_group = module_param('exec_group', 'root')

      $apt_always_apt_update = module_param('apt_always_apt_update', false)
      $apt_disable_keys = module_param('apt_disable_keys', false)
      $apt_proxy_host = module_param('apt_proxy_host', false)
      $apt_proxy_port = module_param('apt_proxy_port', '8080')
      $apt_purge_sources_list = module_param('apt_purge_sources_list', false)
      $apt_purge_sources_list_d = module_param('apt_purge_sources_list_d', false)
      $apt_purge_preferences_d = module_param('apt_purge_preferences_d', false)

      $setup_package_names = module_array('setup_package_names')
      $build_package_names = module_array('build_package_names', ['build-essential', 'libnl-dev', 'libpopt-dev', 'libxml2-dev', 'libssl-dev', 'libcurl4-openssl-dev'])
      $common_package_names = module_array('common_package_names', ['git', 'vim', 'unzip', 'curl'])
      $extra_package_names = module_array('extra_package_names')
      $runtime_package_names = module_array('runtime_package_names')

      $fact_env_file = module_param('fact_env_file', '/etc/profile.d/facts.sh')
      $vagrant_env_file = module_param('vagrant_env_file', '/etc/profile.d/vagrant_ruby.sh')

      # OS Ruby
      $ruby_package_names = module_array('ruby_package_names', ['ruby1.9.1', 'ruby1.9.1-dev'])
      $ruby_extra_package_names = module_array('ruby_extra_package_names', ['rubygems1.9.1'])

      $ruby_exec = module_param('ruby_exec', '/usr/bin/ruby1.9.1')
      $rubygems_exec = module_param('rubygems_exec', '/usr/bin/gem1.9.1')
      $ruby_env_file = module_param('ruby_env_file', '/etc/profile.d/ruby.sh')
      $gem_home = module_param('gem_home', '/var/lib/gems/1.9')

      $ruby_variables = module_hash('ruby_variables', {
        'RUBYOPT' => 'rubygems',
        'GEM_HOME' => $gem_home,
        'GEM_PATH' => $gem_home
      })

      $ruby_set_active_command = module_param('ruby_set_active_command', "update-alternatives --set ruby ${ruby_exec}")
      $gem_set_active_command = module_param('gem_set_active_command', "update-alternatives --set gem ${rubygems_exec}")

      # OS Puppet
      $puppet_apt_location = module_param('puppet_apt_location', 'http://apt.puppetlabs.com')
      $puppet_apt_repos = module_param('puppet_apt_repos', 'main')
      $puppet_apt_key = module_param('puppet_apt_key', '4BD6EC30')
      $puppet_apt_key_server = module_param('puppet_apt_key_server', 'pgp.mit.edu')

      $puppet_package_names = module_array('puppet_package_names', ['puppet'])
      $puppet_extra_package_names = module_array('puppet_extra_package_names', ['vim-puppet'])

      $puppet_config_template = module_param('puppet_config_template', 'PuppetConf')

      $puppet_init_config_file = module_param('puppet_init_config_file', '/etc/default/puppet')
      $puppet_tagmail_template = module_param('puppet_tagmail_template', 'coral/tagmail.conf.erb')

      # For available options, see: http://docs.puppetlabs.com/references/3.1.latest/configuration.html
      $puppet_config = module_hash('puppet_config', {
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

      $puppet_manifest = interpolate($puppet_config['main']['manifest'], $puppet_config['main'])
      $puppet_config_file = interpolate($puppet_config['main']['config'], $puppet_config['main'])
      $puppet_hiera_config_file = interpolate($puppet_config['main']['hiera_config'], $puppet_config['main'])
      $puppet_tagmail_config_file = interpolate($puppet_config['main']['tagmap'], $puppet_config['main'])
      $puppet_report_dir = interpolate($puppet_config['main']['reportdir'], $puppet_config['main'])

      $puppet_hiera_config_template = module_param('puppet_hiera_config_template', 'coral/hiera.puppet.yaml.erb')

      $puppet_bin = module_param('puppet_bin', "/usr/bin/puppet")
      $puppet_service_name = module_param('puppet_service_name', 'puppet')

      $puppet_daemon_env = module_hash('puppet_daemon_env', {
        'DAEMON_OPTS' => ''
      })

      $puppet_update_environment = module_param('puppet_update_environment', 'PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin')
      $puppet_update_command = module_param('puppet_update_command', "${puppet_bin} apply '${puppet_manifest}'")

      $hiera_config = module_param('hiera_config', '/etc/hiera.yaml')
      $hiera_config_template = module_param('hiera_config_template', 'coral/hiera.yaml.erb')

      $hiera_backends = module_array('hiera_backends', [
        module_hash('hiera_json_backend', {
          'type' => 'json',
          'datadir' => '/var/lib/hiera',
        })
      ])
    }
    default : {
      $exec_path = module_array('exec_path', ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'])
      $exec_user = module_param('exec_user', 'root')
      $exec_group = module_param('exec_group', 'root')

      fail("The Ruby and Puppet components in this module are not currently configured for ${::operatingsystem}. See coral module params.pp.")
    }
  }
}
