# == Class profile_development::params
#
# This class is meant to be called from profile_development.
# It sets variables according to platform.
#
class profile_development::params {
  case $::operatingsystem {
    'Debian': {
      $devuser = 'debian'
      $packages = ['ruby2.3', 'ruby2.3-dev', 'git' ,'bundler', 'unzip','awscli', 'python-novaclient', 'python-neutronclient', 'python-glanceclient', 'software-properties-common', 'ansible', 'azure-cli', 'jq']
    }
    'Ubuntu': {
      $devuser = 'ubuntu'
      $packages = ['ruby2.3', 'ruby2.3-dev', 'git' ,'bundler', 'unzip','awscli', 'python-novaclient', 'python-neutronclient', 'python-glanceclient', 'software-properties-common', 'ansible', 'azure-cli', 'jq']
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
