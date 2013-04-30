
class coral::params {
  $base_name = 'coral'

  $package_ensure = 'present'

  $gem_names = ['coral']
  $gem_ensure = 'latest'

  $auto_translate = true

  $facts = {}

  $allow_icmp = true

  #---

  case $::operatingsystem {
    debian, ubuntu : {
      $exec_path = ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin']
      $exec_user = 'root'
      $exec_group = 'root'

      $apt_always_apt_update = false
      $apt_disable_keys = false
      $apt_proxy_host = false
      $apt_proxy_port = '8080'
      $apt_purge_sources_list = false
      $apt_purge_sources_list_d = false
      $apt_purge_preferences_d = false

      $setup_package_names = []
      $build_package_names = ['build-essential', 'libnl-dev', 'libpopt-dev', 'libxml2-dev', 'libssl-dev', 'libcurl4-openssl-dev', 'ruby1.9.1-dev']
      $common_package_names = ['ruby1.9.1', 'vim', 'unzip', 'curl']
      $extra_package_names = ['rubygems1.9.1']
      $runtime_package_names = []

      $fact_env_file = '/etc/profile.d/facts.sh'
      $ruby_env_file = '/etc/profile.d/ruby.sh'
      $vagrant_env_file = '/etc/profile.d/vagrant_ruby.sh'
      $env_template_class = 'Environment'

      $ruby_exec = '/usr/bin/ruby1.9.1'
      $rubygems_exec = '/usr/bin/gem1.9.1'

      $ruby_set_active_command = "update-alternatives --set ruby ${ruby_exec}"
      $gem_set_active_command = "update-alternatives --set gem ${rubygems_exec}"

      $gem_home = '/var/lib/gems/1.9'

      $ruby_variables = {
        'RUBYOPT' => 'rubygems',
        'GEM_HOME' => $gem_home,
        'GEM_PATH' => $gem_home
      }
    }
    default : {
      $exec_path = ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin']
      $exec_user = 'root'
      $exec_group = 'root'

      fail("The Ruby components in this module are not currently configured for ${::operatingsystem}. See coral module params.pp.")
    }
  }
}
