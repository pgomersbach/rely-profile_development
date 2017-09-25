define profile_development::githuborg (
  String[1] $orgname = $title,
) {

  exec { $orgname:
    command => "wget --no-check-certificate --quiet -qO- https://api.github.com/orgs/${orgname}/repos | jq '.[].clone_url' | xargs -L 1 git clone",
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  }
}
