# Define: profile_development::githuborg
#
# This define download all github repo's from a organization
#
#
define profile_development::githuborg(
  $orgname = $title,
  $targetdir = $targetdir,
) {

  exec { $orgname:
    command => "wget --no-check-certificate --quiet -qO- https://api.github.com/orgs/${orgname}/repos | jq '.[].clone_url' | xargs -L 1 git clone",
    cwd     => $targetdir,
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    unless  => "wget --no-check-certificate --quiet -qO- https://api.github.com/orgs/${orgname}/repos | jq '.[].clone_url' | cut -f5 -d '/'|cut -f1 -d'.'|head -1| xargs ls",
  }
}
