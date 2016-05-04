# == Class: profile_development
#
# Full description of class profile_development here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class profile_development
{
  class { '::profile_development::install': } ->
  class { '::profile_development::config': } ~>
  class { '::profile_development::service': } ->
  Class['::profile_development']
}
