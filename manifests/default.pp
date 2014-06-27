
class corl::default {

  case $::operatingsystem {
    ubuntu : {
      # Ubuntu Common

      $build_package_names  = ['build-essential', 'cmake', 'bindfs', 'libnl-dev', 'libpopt-dev', 'libssl-dev', 'libcurl4-openssl-dev', 'libxslt1-dev', 'libxml2-dev']
      $common_package_names = ['python-software-properties', 'vim', 'unzip', 'curl']

      # Ubuntu Ruby

      $ruby_package_names       = ['ruby1.9.1', 'ruby1.9.1-dev']
      $ruby_extra_package_names = []

      $ruby_exec     = '/usr/bin/ruby1.9.1'
      $rubygems_exec = '/usr/bin/gem1.9.1'
      $gem_home      = '/var/lib/gems/1.9.1'

      $ruby_env_file        = '/etc/profile.d/ruby.sh'
      $ruby_root_gemrc_file = '/root/.gemrc'

      $ruby_set_repo_command       = undef
      $ruby_package_update_command = undef

      # Ubuntu Puppet

      $puppet_package_name        = 'puppet'
      $puppet_extra_package_names = []

      $puppet_init_config_file = '/etc/default/puppet'

      $puppet_bin = '/usr/bin/puppet'

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

      # Ubuntu release diferentiated properties

      case $::operatingsystemrelease {
        /^1[23].\d+$/: {
          $puppet_package_ensure = '3.4.3-1puppetlabs1'
        }
        /^14.\d+$/: {
          $puppet_package_ensure = '3.4.3-1'
        }
      }
    }
  }
}
