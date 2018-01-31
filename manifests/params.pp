# == Class profile_development::params
#
# This class is meant to be called from profile_development.
# It sets variables according to platform.
#
class profile_development::params {
  case $::operatingsystem {
    'Debian': {
      $devuser = 'debian'
      $packages = ['ruby2.3', 'ruby2.3-dev', 'git' ,'bundler', 'unzip','python-pip', 'python-novaclient', 'python-neutronclient', 'python-glanceclient', 'software-properties-common', 'ansible', 'azure-cli', 'jq']
    }
    'Ubuntu': {
      $devuser = 'ubuntu'
      $packages = ['ruby2.3', 'ruby2.3-dev', 'git' ,'bundler', 'unzip', 'python-pip', 'python-novaclient', 'python-neutronclient', 'python-glanceclient', 'software-properties-common', 'ansible', 'azure-cli', 'jq', 'google-cloud-sdk', 'xvfb', 'gconf-service', 'libasound2', 'libatk1.0-0', 'libcairo2', 'libcups2', 'libfontconfig1', 'libgconf-2-4', 'libgdk-pixbuf2.0-0', 'libgtk-3-0', 'libnspr4', 'libxss1', 'fonts-liberation', 'libappindicator1', 'libnss3', 'xdg-utils', 'python-mysql.connector' ]
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
  $devuserhome = "/home/${devuser}"
}
