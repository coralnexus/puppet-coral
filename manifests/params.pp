
class global::params {

  $setup_ensure   = 'present'
  $build_ensure   = 'present'
  $common_ensure  = 'present'
  $runtime_ensure = 'present'

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

      $setup_packages           = []
      $common_packages          = [ 'vim', 'unzip', 'curl' ]
      $build_packages           = [
        'build-essential',
        'libnl-dev',
        'libpopt-dev',
        'libxml2-dev',
        'libssl-dev',
        'libcurl4-openssl-dev',
      ]
      $runtime_packages         = []

      $fact_environment         = '/etc/profile.d/facts.sh'
      $facts_template           = 'global/facts.sh.erb'
    }
    default: {
      fail("The global module is not currently supported on ${::operatingsystem}")
    }
  }
}
