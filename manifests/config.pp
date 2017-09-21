# == Class profile_development::config
#
# This class is called from profile_development for service config.
#
class profile_development::config {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  # install puppet module skeleton
  vcsrepo { '/tmp/puppet-module-skeleton':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/pgomersbach/puppet-module-skeleton.git',
  }

  exec { 'move org skeleton':
    cwd     => '/opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/module_tool/skeleton/templates',
    command => '/bin/mv generator generator.org',
    creates => '/opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/module_tool/skeleton/templates/generator.org',
    require => Vcsrepo[ '/tmp/puppet-module-skeleton' ],
  }

  exec { 'install skeleton':
    cwd     => '/opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/module_tool/skeleton/templates',
    command => '/bin/cp -a /tmp/puppet-module-skeleton/skeleton ./generator',
    creates => '/opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/module_tool/skeleton/templates/generator',
    require => Exec[ 'move org skeleton' ],
  }

  # create terraform ssh keys

  # install cerificates
  if $::osfamily != 'FreeBSD' {
    class { 'ca_cert':
      install_package => true,
    }

    ca_cert::ca { 'stack_rely_nl':
      ensure            => 'trusted',
      source            => 'https://access.openstack.rely.nl:8080/v1/AUTH_33b4525433f54ffe86d1c2cc305451c5/rely/star_openstack_rely_nl.crt',
      verify_https_cert => false,
    }
  }

}
