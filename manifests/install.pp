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
    apt::ppa { 'ppa:ansible/ansible': }
    apt::ppa { 'ppa:brightbox/ruby-ng':
      before => Package['ruby2.3', 'ruby2.3-dev'],
    }
    class {'::ansible':
      require => Apt::Ppa['ppa:ansible/ansible'],
    }
  }

  if $::osfamily != 'FreeBSD' {
    include hashicorp
    class { 'hashicorp::terraform':
      version => '0.10.0',
    }
  }
}
