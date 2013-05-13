
class coral::default {

  case $::operatingsystem {
    debian, ubuntu : {
      # Debian Common

      $build_package_names  = ['build-essential', 'libnl-dev', 'libpopt-dev', 'libxml2-dev', 'libssl-dev', 'libcurl4-openssl-dev']
      $common_package_names = ['vim', 'unzip', 'curl']

      # Debian Ruby

      $ruby_package_names       = ['ruby1.9.1', 'ruby1.9.1-dev']
      $ruby_extra_package_names = []

      $ruby_exec     = '/usr/bin/ruby1.9.1'
      $rubygems_exec = '/usr/bin/gem1.9.1'
      $gem_home      = '/var/lib/gems/1.9.1'

      # Debian Puppet

      $puppet_package_names       = ['puppet']
      $puppet_extra_package_names = ['vim-puppet']

      $puppet_init_config_file = '/etc/default/puppet'

      $puppet_bin = '/usr/bin/puppet'

      # Debian SSH

      $ssh_package_names       = ['openssh-server']
      $ssh_extra_package_names = ['ssh-import-id']

      $ssh_init_bin = '/etc/init.d/ssh'

      $ssh_config_file = '/etc/ssh/sshd_config'

      # Debian Sudo

      $visudo_bin = '/usr/sbin/visudo'

      $sudoers_file      = '/etc/sudoers'
      $sudoers_test_file = '/etc/sudoers.test'

      $sudoers_dir = '/etc/sudoers.d'
    }
  }
}
