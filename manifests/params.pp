
class coral::params {

  $package_ensure = 'present'

  $auto_translate = true

  $facts          = {}

  $allow_icmp     = true

  #---

  case $::operatingsystem {
    debian, ubuntu: {
      $exec_path                = [ '/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin' ]
      $exec_user                = 'root'
      $exec_group               = 'root'

      $apt_always_apt_update    = false
      $apt_disable_keys         = undef
      $apt_proxy_host           = false
      $apt_proxy_port           = '8080'
      $apt_purge_sources_list   = false
      $apt_purge_sources_list_d = false
      $apt_purge_preferences_d  = false

      $setup_package_names      = []
      $build_package_names      = [
        'build-essential',
        'libnl-dev',
        'libpopt-dev',
        'libxml2-dev',
        'libssl-dev',
        'libcurl4-openssl-dev',
      ]
      $common_package_names     = [ 'vim', 'unzip', 'curl' ]
      $extra_package_names      = []
      $runtime_package_names    = []

      $fact_environment         = '/etc/profile.d/facts.sh'
      $facts_template           = 'coral/facts.sh.erb'
    }
    default: {
      $exec_path  = [ '/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin' ]
      $exec_user  = 'root'
      $exec_group = 'root'
    }
  }
}
