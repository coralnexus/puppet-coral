
class corl::params::sudo inherits corl::default {

  $visudo_bin        = module_param('visudo_bin')
  $sudoers_file      = module_param('sudoers_file')
  $sudoers_test_file = module_param('sudoers_test_file')

  $sudoers_config_owner = module_param('sudoers_config_owner', 'root')
  $sudoers_config_group = module_param('sudoers_config_group', 'root')
  $sudoers_config_mode  = module_param('sudoers_config_mode', '0440')

  $sudoers_template      = module_param('sudoers_template', 'sudoersconf')
  $sudoers_template_file = module_param('sudoers_template_file', 'corl/sudoers.erb')

  $sudoers_dir = module_param('sudoers_dir')

  # See: http://www.sudo.ws/sudoers.man.html
  $sudoers_config = module_hash('sudoers_config', {
    'defaults' => {
      'Defaults' => {
        'env_reset'   => '',
        'secure_path' => '"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"'
      }
    },
    'aliases' => {
      'User_Alias'  => {},
      'Runas_Alias' => {},
      'Host_Alias'  => {},
      'Cmnd_Alias'  => {}
    },
    'specs' => {
      'root'  => 'ALL=(ALL:ALL) ALL',
      '%sudo' => 'ALL=(ALL:ALL) NOPASSWD:ALL'
    }
  })

  $sudoers_test_command = module_param('sudoers_test_command', "${visudo_bin} -cf ${sudoers_test_file}")
}
