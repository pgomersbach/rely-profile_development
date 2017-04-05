# == Class profile_development::params
#
# This class is meant to be called from profile_development.
# It sets variables according to platform.
#
class profile_development::params {
  case $::operatingsystem {
    'Debian': {
      $devuser = 'debian'
    }
    'Ubuntu': {
      $devuser = 'ubuntu'
    }
    'CentOS': {
      $devuser = 'centos'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
