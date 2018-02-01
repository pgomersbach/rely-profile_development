# == Class profile_development::install
#
# This class is called from profile_development for install.
#
class profile_development::install {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $::osfamily == 'debian' {
    # add repositories
    include apt
    apt::ppa { 'ppa:ansible/ansible':
      before => Package['ansible'],
      notify => Exec['apt_update'],
    }
    apt::ppa { 'ppa:brightbox/ruby-ng':
      before => Package['ruby2.3', 'ruby2.3-dev'],
      notify => Exec['apt_update'],
    }
    apt::source { 'azurecli':
      location => 'https://packages.microsoft.com/repos/azure-cli/',
      release  => 'wheezy',
      repos    => 'main',
      key      => {
        'id'     => '52E16F86FEE04B979B07E28DB02C46DF417A0893',
        'server' => 'packages.microsoft.com',
      },
      before   => Package['azure-cli'],
      notify   => Exec['apt_update'],
    }
    apt::source { 'gcloud':
      location => 'http://packages.cloud.google.com/apt',
      release  => 'cloud-sdk-xenial',
      repos    => 'main',
      key      => {
        'id'     => 'D0BC747FD8CAF7117500D6FA3746C208A7317B0F',
        'source' => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg',
      },
      before   => Package['google-cloud-sdk'],
      notify   => Exec['apt_update'],
    }
  }

  ensure_packages( $profile_development::packages, {'ensure' => 'latest', require => Exec['apt_update'], before => Package['chrome'],} )



  package { 'awscli':
    ensure   => 'installed',
    provider => pip,
    require  => Package['python-pip'],
  }

  package { 'selenium':
    ensure   => 'installed',
    provider => pip,
    require  => Package['python-pip'],
  }

  package { ['selenium-webdriver', 'rspec']:
    ensure   => 'installed',
    provider => gem,
  }

  user { $profile_development::devuser:
    ensure => present,
    home   => $profile_development::devuserhome,
  }

  file { $profile_development::devuserhome:
    ensure  => directory,
    owner   => $profile_development::devuser,
    require => User[$profile_development::devuser],
  }

  # generate standard ssh key
  ssh_keygen { $profile_development::devuser:
    require => File[$profile_development::devuserhome],
  }

  # install terraform
  include hashicorp
  class { 'hashicorp::terraform':
    version => '0.11.2',
    require => Package['unzip'],
  }

  # install chromedriver
  remote_file { 'chromedriver':
    ensure => present,
    path   => '/tmp/chromedriver.zip',
    source => 'http://chromedriver.storage.googleapis.com/2.35/chromedriver_linux64.zip',
  }

  exec { 'unzip_chromedriver':
    command => '/usr/bin/unzip chromedriver.zip && mv chromedriver /usr/local/bin/',
    cwd     => '/tmp',
    creates => '/usr/local/bin/chromedriver',
    require => [ Package['unzip'], Remote_file['chromedriver'] ],
  }

  # install chrome
  remote_file { 'chrome':
    ensure => present,
    path   => '/tmp/chrome.deb',
    source => 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb',
  }

  package { 'chrome':
    ensure   => latest,
    provider => dpkg,
    source   => '/tmp/chrome.deb',
  }

  # install kops
  remote_file { 'kops':
    ensure => present,
    path   => '/usr/local/bin/kops',
    source => 'https://github.com/kubernetes/kops/releases/download/1.8.0/kops-linux-amd64',
  }

  file { 'kops_flags':
    path    => '/usr/local/bin/kops',
    mode    => '0755',
    require => Remote_file[ 'kops'],
  }

  # install kubectl
  remote_file { 'kubectl':
    ensure => 'present',
    path   => '/usr/local/bin/kubectl',
    source => 'https://storage.googleapis.com/kubernetes-release/release/v1.9.2/bin/linux/amd64/kubectl',
  }

  file { 'kubectl_flags':
    path    => '/usr/local/bin/kubectl',
    mode    => '0755',
    require => Remote_file[ 'kubectl'],
  }

}
