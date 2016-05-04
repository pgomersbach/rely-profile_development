# == Class profile_development::install
#
# This class is called from profile_development for install.
#
class profile_development::install {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  ensure_packages( ['git' ,'bundler', 'unzip', 'awscli'] )

  class { 'terraform':
    version => '0.6.15',
  }
}
