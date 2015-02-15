
class corl::default {

  case $::operatingsystem {
    ubuntu : {
      # Ubuntu Common

      $build_package_names  = [
        'build-essential',
        'cmake',
        'bindfs',
        'libnl-dev',
        'libpopt-dev',
        'libssl-dev',
        'libcurl4-openssl-dev',
        'libxslt1-dev',
        'libxml2-dev',
        'libyaml-dev',
        'libreadline-dev',
        'libncurses5-dev',
        'zlib1g-dev',
        'texinfo',
        'llvm',
        'llvm-dev'
      ]
      $common_package_names = [
        'python-software-properties',
        'vim',
        'unzip',
        'curl',
        'bison'
      ]

      # Ubuntu Ruby

      $ruby_env_file        = '/etc/profile.d/ruby.sh'
      $ruby_root_gemrc_file = '/root/.gemrc'

      # Ubuntu Puppet

      $puppet_package_name        = 'puppet'
      $puppet_package_ensure      = '3.7.4-1puppetlabs1'
      $puppet_extra_package_names = []

      $puppet_init_config_file = '/etc/default/puppet'

      # Ubuntu SSH

      $ssh_package_names       = ['openssh-server']
      $ssh_extra_package_names = ['ssh-import-id']

      $sshd_config_file = '/etc/ssh/sshd_config'
      $ssh_config_file  = '/etc/ssh/ssh_config'

      # Ubuntu Sudo

      $visudo_bin = '/usr/sbin/visudo'

      $sudoers_file      = '/etc/sudoers'
      $sudoers_test_file = '/etc/sudoers.test'

      $sudoers_dir = '/etc/sudoers.d'

      # Ubuntu CORL logging

      $log_dir = '/var/log/corl'
    }
  }
}
