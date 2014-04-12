
class corl::default {

  case $::operatingsystem {
    debian, ubuntu : {
      # Debian Common

      $build_package_names  = ['build-essential', 'libnl-dev', 'libpopt-dev', 'libxml2-dev', 'libssl-dev', 'libcurl4-openssl-dev', 'libxslt1-dev']
      $common_package_names = ['vim', 'unzip', 'curl', 'python-software-properties']

      # Debian Ruby

      $ruby_package_names       = ['ruby2.0', 'ruby2.0-dev']
      $ruby_extra_package_names = []

      $ruby_exec     = '/usr/bin/ruby2.0'
      $rubygems_exec = '/usr/bin/gem2.0'
      $gem_home      = '/var/lib/gems/2.0.0'

      $ruby_env_file        = '/etc/profile.d/ruby.sh'
      $ruby_root_gemrc_file = '/root/.gemrc'

      $ruby_set_repo_command       = "add-apt-repository -y ppa:brightbox/ruby-ng-experimental"
      $ruby_package_update_command = 'apt-get update'

      # Debian Puppet

      $puppet_package_names       = ['puppet']
      $puppet_extra_package_names = ['vim-puppet']

      $puppet_init_config_file = '/etc/default/puppet'

      $puppet_bin = '/usr/bin/puppet'

      # Debian SSH

      $ssh_package_names       = ['openssh-server']
      $ssh_extra_package_names = ['ssh-import-id']

      $ssh_init_bin = '/etc/init.d/ssh'

      $sshd_config_file = '/etc/ssh/sshd_config'
      $ssh_config_file  = '/etc/ssh/ssh_config'

      # Debian Sudo

      $visudo_bin = '/usr/sbin/visudo'

      $sudoers_file      = '/etc/sudoers'
      $sudoers_test_file = '/etc/sudoers.test'

      $sudoers_dir = '/etc/sudoers.d'

      # Debian Coral logging

      $log_dir = '/var/log/corl'
    }
  }
}
