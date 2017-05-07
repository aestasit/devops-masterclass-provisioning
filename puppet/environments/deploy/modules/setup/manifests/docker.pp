class setup::docker {

  class { '::docker':
    package_name                => 'docker-ce',
    use_upstream_package_source => false
  }

  exec { 'docker swarm init':
    command     => "docker swarm init",
    environment => 'HOME=/root',
    path        => ['/bin', '/usr/bin'],
    timeout     => 0,
    unless      => 'docker info | grep -w "Swarm: active"',
    require     => Class['::docker']
  }

  file { '/var/lib/registry':
    ensure => directory
  }

  file { [
    '/etc/docker/registry',
    '/etc/docker/registry/certs'
  ]:
    ensure => directory
  }

  # TODO: add certificates

  docker::run { 'registry':
    image            => "registry:2",
    ports            => [ '5000:5000' ],
    # env              => [
    #   "REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt",
    #   "REGISTRY_HTTP_TLS_KEY=/certs/domain.key"
    # ],
    restart_service  => true,
    volumes          => [
      "/var/lib/registry:/var/lib/registry",
      "/etc/docker/registry/certs:/certs",
    ],
    extra_parameters => [
      '--restart=always',
    ],
    require          => [
      File['/var/lib/registry'],
      File['/etc/docker/registry/certs']
    ]
  }

  # TODO: add virtual host for registry??

}