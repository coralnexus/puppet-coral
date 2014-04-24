class corl::default {

  case $::operatingsystem {
    debian, ubuntu : {
      # Debian Common

      $build_package_names  = ['build-essential', 'libnl-dev', 'libpopt-dev', 'libssl-dev', 'libcurl4-openssl-dev', 'libxslt-dev', 'libxml2-dev']
      $common_package_names = ['vim', 'unzip', 'curl']

      $package_helper       = 'python-software-properties'

      # Debian Ruby

      $ruby_package_names       = ['ruby2.1', 'ruby2.1-dev']
      $ruby_extra_package_names = []

      $ruby_exec     = '/usr/bin/ruby2.1'
      $rubygems_exec = '/usr/bin/gem2.1'
      $gem_home      = '/var/lib/gems/2.1.0'

      $ruby_env_file        = '/etc/profile.d/ruby.sh'
      $ruby_root_gemrc_file = '/root/.gemrc'

      $ruby_set_repo_command       = "add-apt-repository -y ppa:brightbox/ruby-ng"
      $ruby_package_update_command = 'apt-get update'

      # Debian Puppet

      $puppet_package_name        = 'puppet'
      $puppet_package_ensure      = '3.4.3-1puppetlabs1'
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
