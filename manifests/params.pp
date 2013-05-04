
class coral::params {
  coral_initialize()

  $time = time()

  # Names
  $base_name = 'coral'

  $ruby_name = "${base_name}_ruby"
  $puppet_name = "${base_name}_puppet"
  $ssh_name = "${base_name}_ssh"
  $sudo_name = "${base_name}_sudo"

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

  # SSH
  $ssh_service_ensure = 'running'

  $firewall_ssh_name = module_param('firewall_ssh_name', '150 INPUT Allow new SSH connections')

  #---

  case $::operatingsystem {
    debian, ubuntu : {
      # Debian Common
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

      # Debian Ruby
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

      # Debian Puppet
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

      # Debian SSH
      $ssh_package_names = module_array('ssh_package_names', ['openssh-server'])
      $ssh_extra_package_names = module_array('ssh_extra_package_names', ['ssh-import-id'])

      $ssh_service_name = module_param('ssh_service_name', 'ssh')

      $ssh_init_bin = module_param('ssh_init_bin', '/etc/init.d/ssh')
      $ssh_init_reload = module_param('ssh_init_reload', 'reload')
      $ssh_init_command = module_param('ssh_init_command', "${ssh_init_bin} ${ssh_init_reload}")

      $ssh_config_file = module_param('ssh_config_file', '/etc/ssh/sshd_config')
      $ssh_config_template = module_param('ssh_config_template', 'SSHConf')

      $ssh_config_owner = module_param('ssh_config_owner', 'root')
      $ssh_config_group = module_param('ssh_config_group', 'root')
      $ssh_config_mode = module_param('ssh_config_mode', '0644')

      # For available options, see: http://unixhelp.ed.ac.uk/CGI/man-cgi?sshd_config+5
      $ssh_config = module_hash('ssh_config', {
        'Port'                            => 22,
        'Protocol'                        => 2,
        'HostKey'                         => [ '/etc/ssh/ssh_host_rsa_key', '/etc/ssh/ssh_host_dsa_key', '/etc/ssh/ssh_host_ecdsa_key' ],
        'UsePrivilegeSeparation'          => 'yes',
        'KeyRegenerationInterval'         => 3600,
        'ServerKeyBits'                   => 768,
        'SyslogFacility'                  => 'AUTH',
        'LogLevel'                        => 'INFO',
        'LoginGraceTime'                  => 120,
        'PermitRootLogin'                 => 'yes',
        'StrictModes'                     => 'yes',
        'RSAAuthentication'               => 'yes',
        'PubkeyAuthentication'            => 'yes',
        'AuthorizedKeysFile'              => '%h/.ssh/authorized_keys',
        'IgnoreRhosts'                    => 'yes',
        'RhostsRSAAuthentication'         => 'no',
        'HostbasedAuthentication'         => 'no',
        'PermitEmptyPasswords'            => 'no',
        'ChallengeResponseAuthentication' => 'no',
        'PasswordAuthentication'          => 'yes',
        'X11Forwarding'                   => 'yes',
        'X11DisplayOffset'                => 10,
        'PrintMotd'                       => 'yes',
        'PrintLastLog'                    => 'yes',
        'TCPKeepAlive'                    => 'yes',
        'AcceptEnv'                       => 'LANG LC_*',
        'Subsystem'                       => 'sftp /usr/lib/openssh/sftp-server',
        'UsePAM'                          => 'yes',
        'UseDNS'                          => 'no',
        'AllowGroups'                     => [ 'root', 'admin', 'vagrant' ]
      })

      $ssh_port = interpolate($ssh_config['Port'], $ssh_config)

      # Debian Sudo
      $visudo_bin = module_param('visudo_bin', '/usr/sbin/visudo')
      $sudoers_file = module_param('sudoers_file', '/etc/sudoers')
      $sudoers_test_file = module_param('sudoers_test_file', '/etc/sudoers.test')

      $sudoers_config_owner = module_param('sudoers_config_owner', 'root')
      $sudoers_config_group = module_param('sudoers_config_group', 'root')
      $sudoers_config_mode = module_param('sudoers_config_mode', '0440')

      $sudoers_template = module_param('sudoers_template', 'SudoersConf')
      $sudoers_template_file = module_param('sudoers_template_file', 'coral/sudoers.erb')

      $sudoers_dir = module_param('sudoers_dir', '/etc/sudoers.d')

      # See: http://www.sudo.ws/sudoers.man.html
      $sudoers_config = module_hash('sudoers_config', {
        'defaults' => {
          'Defaults' => {
            'env_reset'   => '',
            'secure_path' => '"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"'
          }
        },
        'aliases' => {
          'User_Alias'  => {},
          'Runas_Alias' => {},
          'Host_Alias'  => {},
          'Cmnd_Alias'  => {}
        },
        'specs' => {
          'root'  => 'ALL=(ALL:ALL) ALL',
          '%sudo' => 'ALL=(ALL:ALL) NOPASSWD:ALL'
        }
      })

      $sudoers_test_command = module_param('sudoers_test_command', "${visudo_bin} -cf ${sudoers_test_file}")
    }
    default : {
      $exec_path = module_array('exec_path', ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'])
      $exec_user = module_param('exec_user', 'root')
      $exec_group = module_param('exec_group', 'root')

      fail("The Ruby and Puppet components in this module are not currently configured for ${::operatingsystem}. See coral module params.pp.")
    }
  }
}
