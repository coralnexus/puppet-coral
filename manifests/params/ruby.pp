
class corl::params::ruby inherits corl::default {

  $gem_names  = module_array('gem_names')
  $gem_ensure = module_param('gem_ensure', 'latest')

  $env_file = module_param('ruby_env_file')

  $root_gemrc_file = module_param('ruby_root_gemrc_file')
  $root_gemrc      = module_param('ruby_root_gemrc', 'gem: --no-rdoc --no-ri')

  $variables = module_hash('ruby_variables', {
    'RUBYOPT' => 'rubygems'
  })
}
