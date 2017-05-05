
class setup::docker {

  class { '::docker':
    package_name => 'docker-ce',
    use_upstream_package_source => false
  }

  # TODO: docker registry

  # TODO: add virtual host for registry??

  # TODO; docker swarm

}