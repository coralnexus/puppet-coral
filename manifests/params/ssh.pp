
class coral::params::ssh inherits coral::default {

  $package_names       = module_array('ssh_package_names')
  $extra_package_names = module_array('ssh_extra_package_names')

  $init_bin     = module_param('ssh_init_bin')
  $init_reload  = module_param('ssh_init_reload', 'reload')
  $init_command = module_param('ssh_init_command', "${init_bin} ${init_reload}")

  $config_file     = module_param('ssh_config_file')
  $config_template = module_param('ssh_config_template', 'ssh')

  $config_owner = module_param('ssh_config_owner', 'root')
  $config_group = module_param('ssh_config_group', 'root')
  $config_mode  = module_param('ssh_config_mode', '0644')

  # For available options, see: http://unixhelp.ed.ac.uk/CGI/man-cgi?sshd_config+5
  $config = module_hash('ssh_config', {
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
    'AllowGroups'                     => [ 'root', 'vagrant' ]
  })
  $port = interpolate($config['Port'], $config)

  $firewall_name = module_param('firewall_ssh_name', '150 INPUT Allow new SSH connections')

  $service_name   = module_param('ssh_service_name', 'ssh')
  $service_ensure = module_param('ssh_service_ensure', 'running')
}
