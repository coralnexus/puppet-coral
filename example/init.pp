
node default {
  # This should be placed inside your top level node...
  #
  # See: site.pp  ( http://github.com/coraltech/puppet-lib )
  #
  resources { "firewall":
    purge => true
  }
  Firewall {
    before  => Class['global::firewall_post_rules'],
    require => Class['global::firewall_pre_rules'],
  }
  class { 'global':
    facts => global_hash('global::facts')
  }
  Exec {
    user => global_param('global::exec_user'),
    path => global_param('global::exec_path'),
  }
}
