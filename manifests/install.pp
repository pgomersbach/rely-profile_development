# == Class profile_development::install
#
# This class is called from profile_development for install.
#
class profile_development::install {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  ensure_packages( $profile_development::packages )

  if $::osfamily == 'debian' {
    # add ruby and ansible repository
    include apt
    apt::ppa { 'ppa:ansible/ansible':
      before => Package['ansible'],
    }
    apt::ppa { 'ppa:brightbox/ruby-ng':
      before => Package['ruby2.3', 'ruby2.3-dev'],
    }
  }

  if $::osfamily != 'FreeBSD' {
    include hashicorp
    class { 'hashicorp::terraform':
      version => '0.10.6',
    }
  }

  # install kops
  file { 'kops':
    ensure => 'file',
    path   => '/usr/local/bin/kops',
    mode   => 'a+x',
    source => 'https://github.com/kubernetes/kops/releases/download/1.7.0/kops-linux-amd64',
  }
  # install kubctl
  file { 'kubctl':
    ensure => 'file',
    path   => '/usr/local/bin/kubctl',
    mode   => 'a+x',
    source => 'https://storage.googleapis.com/kubernetes-release/release/v1.7.6/bin/linux/amd64/kubectl',
  }

}
