# == Class profile_development::install
#
# This class is called from profile_development for install.
#
class profile_development::install {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  ensure_packages( $profile_development::packages, {'ensure' => 'latest'} )

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
        'id'     => '417A0893',
        'server' => 'packages.microsoft.com',
      },
      before   => Package['azure-cli'],
      notify   => Exec['apt_update'],
    }
  }

  include hashicorp
  class { 'hashicorp::terraform':
    version => '0.10.6',
  }

  # install kops
  remote_file { 'kops':
    ensure => present,
    path   => '/usr/local/bin/kops',
    source => 'https://github.com/kubernetes/kops/releases/download/1.7.0/kops-linux-amd64',
  }
  file { 'kops_flags':
    path    => '/usr/local/bin/kops',
    mode    => '0755',
    require => Remote_file[ 'kops'],
  }

  # install kubctl
  remote_file { 'kubctl':
    ensure => 'present',
    path   => '/usr/local/bin/kubctl',
    source => 'https://storage.googleapis.com/kubernetes-release/release/v1.7.6/bin/linux/amd64/kubectl',
  }
  file { 'kubctl_flags':
    path    => '/usr/local/bin/kubctl',
    mode    => '0755',
    require => Remote_file[ 'kubctl'],
  }

}
