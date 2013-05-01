/**
 * Gateway manifest to all Puppet classes.
 *
 * Note: This is the only node in this system.  We use it to dynamically
 * bootstrap or load and manage classes (profiles).
 *
 * This should allow the server to configure it's own profiles in the future.
 */
node default {

  Exec {
    logoutput => "on_failure",
  }

  #---

  # This assumes the manifest core has been added to the {project dir}/core
  # directory.
  import "core/*.pp"
  include coral::default

  #---

  resources { "firewall":
    purge => true
  }
  Firewall {
    before  => Class['coral::firewall::post_rules'],
    require => Class['coral::firewall::pre_rules'],
  }

  include coral
  Class['coral::default'] -> Class['coral']

  Exec {
    user => $coral::params::exec_user,
    path => $coral::params::exec_path
  }

  #---

  if ! ( config_initialized and exists(global_param('config::common')) ) {
    $config_address = global_param('config::address')

    notice "Bootstrapping server"
    notice "Push configurations to: ${config_address}"

    include bootstrap
    Class['coral'] -> Class['bootstrap']
  }
  else {
    import "profiles/*.pp"

    include base
    Class['coral'] -> Class['base']

    coral_include('profiles')
  }
}
