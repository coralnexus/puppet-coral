
class corl::params {

  # Names

  $base_name     = 'corl'

  $ruby_name     = "${base_name}_ruby"
  $manage_ruby   = module_param('manage_ruby', true)

  $puppet_name   = "${base_name}_puppet"
  $manage_puppet = module_param('manage_puppet', true)

  $ssh_name      = "${base_name}_ssh"
  $manage_ssh    = module_param('manage_ssh', true)

  $sudo_name     = "${base_name}_sudo"
  $manage_sudo   = module_param('manage_sudo', true)

  $setup_name    = "${base_name}_setup"
  $runtime_name  = "${base_name}_runtime"

  # Common

  $apt_always_apt_update    = module_param('apt_always_apt_update', false)
  $apt_disable_keys         = module_param('apt_disable_keys', false)
  $apt_proxy_host           = module_param('apt_proxy_host', false)
  $apt_proxy_port           = module_param('apt_proxy_port', '8080')
  $apt_purge_sources_list   = module_param('apt_purge_sources_list', false)
  $apt_purge_sources_list_d = module_param('apt_purge_sources_list_d', false)
  $apt_purge_preferences_d  = module_param('apt_purge_preferences_d', false)

  $package_ensure        = module_param('package_ensure', 'present')
  $setup_package_names   = module_array('setup_package_names')
  $build_package_names   = module_array('build_package_names')
  $common_package_names  = module_array('common_package_names')
  $extra_package_names   = module_array('extra_package_names')
  $runtime_package_names = module_array('runtime_package_names')

  $json_template = module_param('json_template', 'json')
  $env_template  = module_param('env_template', 'environment')

  $fact_env_file = module_param('fact_env_file', '/etc/profile.d/facts.sh')
  $facts         = module_hash('facts')

  $vagrant_env_file = module_param('vagrant_env_file', '/etc/profile.d/vagrant_ruby.sh')

  $firewall_icmp_name                = module_param('firewall_icmp_name', '101 INPUT allow ICMP')
  $firewall_loopback_input_name      = module_param('firewall_loopback_input_name', '001 INPUT allow loopbacks')
  $firewall_loopback_output_name     = module_param('firewall_loopback_output_name', '002 OUTPUT allow loopback')
  $firewall_related_established_name = module_param('firewall_related_established_name', '050 Allow related and established')
  $firewall_all_outbound_name        = module_param('firewall_all_outbound_name', '090 OUTPUT allow all outbound')
  $firewall_log_rejected_name        = module_param('firewall_log_rejected_name', '950 INPUT log all rejected')
  $firewall_reject_all_name          = module_param('firewall_reject_all_name', '999 Reject all')

  $exec_path  = module_array('exec_path', ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'])
  $exec_user  = module_param('exec_user', 'root')
  $exec_group = module_param('exec_group', 'root')

  # Logging

  $config_template    = module_param('config_template', 'Configuration')

  $log_dir            = module_param('log_dir')
  $log_dir_mode       = module_param('log_dir_mode', '0744')
  $property_store     = module_param('property_store', true)
  $property_file      = module_param('property_file', 'common.json')
  $property_file_mode = module_param('property_file_mode', '0744')
  $property_path      = "${log_dir}/${property_file}"
  $log_owner          = module_param('log_owner', 'root')
  $log_group          = module_param('log_group', 'root')
}
