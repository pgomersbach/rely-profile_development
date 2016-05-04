# == Class profile_development::service
#
# This class is meant to be called from profile_development.
# It ensure the service is running.
#
class profile_development::service {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  service { $::profile_development::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
