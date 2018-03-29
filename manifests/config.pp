# == Class profile_development::config
#
# This class is called from profile_development for service config.
#
class profile_development::config {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  # clone github repos for organization
  profile_development::githuborg { 'relybv':
    targetdir => $profile_development::devuserhome,
  }

  # install puppet module skeleton
  vcsrepo { '/tmp/puppet-module-skeleton':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/relybv/puppet-module-skeleton.git',
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

  # install latest ansible f5 modules
  vcsrepo { '/tmp/f5-ansible':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/F5Networks/f5-ansible.git',
  }

  exec { 'move org f5-ansible':
    cwd     => '/usr/local/lib/python2.7/dist-packages/ansible/modules/network/',
    command => '/bin/mv f5 /tmp/f5.org',
    creates => '/tmp/f5.org',
    require => Vcsrepo[ '/tmp/f5-ansible' ],
  }

  exec { 'install f5-ansible':
    command => '/bin/cp -a /tmp/f5-ansible/library /usr/local/lib/python2.7/dist-packages/ansible/modules/network/f5',
    creates => '/usr/local/lib/python2.7/dist-packages/ansible/modules/network/f5',
    require => Vcsrepo[ '/tmp/f5-ansible' ],
  }

  # clone ansible f5 provisioning repo
  vcsrepo { '/etc/ansible/f5-ansible_automation':
    ensure   => latest,
    provider => git,
    source   => 'https://github.com/relybv/f5-ansible_automation.git',
  }

  exec { 'f5-ansible-requirements':
    cwd     => '/etc/ansible/f5-ansible_automation',
    command => '/usr/bin/pip install -r requirements.txt',
  }

  # create terraform ssh keys

  # install cerificates
  class { 'ca_cert':
    install_package => true,
  }

  ca_cert::ca { 'stack_rely_nl':
    ensure            => 'trusted',
    source            => 'https://access.openstack.rely.nl:8080/v1/AUTH_33b4525433f54ffe86d1c2cc305451c5/rely/star_openstack_rely_nl.crt',
    verify_https_cert => false,
  }
}

