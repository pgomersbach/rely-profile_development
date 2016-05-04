# == Class profile_development::params
#
# This class is meant to be called from profile_development.
# It sets variables according to platform.
#
class profile_development::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'profile_development'
      $service_name = 'profile_development'
    }
    'RedHat', 'Amazon': {
      $package_name = 'profile_development'
      $service_name = 'profile_development'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
