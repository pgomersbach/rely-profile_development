# == Class profile_development::config
#
# This class is called from profile_development for service config.
#
class profile_development::config {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

}
