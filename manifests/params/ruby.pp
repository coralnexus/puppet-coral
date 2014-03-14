
class corl::params::ruby inherits corl::default {

  $package_names       = module_array('ruby_package_names')
  $extra_package_names = module_array('ruby_extra_package_names')

  $ruby_exec     = module_param('ruby_exec')
  $rubygems_exec = module_param('rubygems_exec')

  $gem_names  = module_array('gem_names', ['libshadow', 'corl'])
  $gem_ensure = module_param('gem_ensure', 'latest')

  $env_file = module_param('ruby_env_file', '/etc/profile.d/ruby.sh')
  $gem_home = module_param('gem_home')

  $variables = module_hash('ruby_variables', {
    'RUBYOPT' => 'rubygems',
    'GEM_HOME' => $gem_home,
    'GEM_PATH' => $gem_home
  })

  $set_active_command     = module_param('ruby_set_active_command', "update-alternatives --set ruby ${ruby_exec}")
  $gem_set_active_command = module_param('gem_set_active_command', "update-alternatives --set gem ${rubygems_exec}")
}
