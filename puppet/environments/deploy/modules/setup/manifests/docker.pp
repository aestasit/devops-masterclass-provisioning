
class setup::docker {

  contain '::docker::params'

  package { ['debian-keyring', 'debian-archive-keyring']:
    ensure => installed
  }

  apt::source { 'docker':
    location          => $docker::params::package_source_location,
    release           => $docker::params::package_release,
    repos             => $docker::params::package_repos,
    key               => {
      id         => $docker::params::package_key,
      source     => $docker::params::package_key_source,
    },
    pin               => '10',
    include           => { 'src' => false }
  }

  class { '::docker':
    service_name                => 'docker',
    docker_command              => 'docker',
    use_upstream_package_source => false,
    require                     => [
      Package['debian-keyring'], 
      Package['debian-archive-keyring'],
      Apt::Source['docker']
    ]
  }

  # TODO: setup rancher instead 

  Docker::Run {
    restart          => 'always',
    detach           => true,
    extra_parameters => [ '-ti' ]
  }

  docker::run { 'shipyard-rethinkdb':
    image   => 'rethinkdb:latest',
  }
 
  docker::run { 'shipyard-discovery':
    image   => 'microbox/etcd:latest',
    ports   => [ '4001:4001', '7001:7001' ],
    command => '-name discovery'
  }

  docker::run { 'shipyard-proxy':
    image         => 'ehazlett/docker-proxy:latest',
    ports         => [ '2375:2375' ],
    env           => [ 'PORT=2375' ],
    hostname      => $::hostname,
    volumes       => [ '/var/run/docker.sock:/var/run/docker.sock' ],
    command       => "/bin/docker-proxy -D"
  }

  docker::run { 'shipyard-swarm-manager':
    image   => 'swarm:latest',
    command => "manage --host tcp://0.0.0.0:3375 etcd://${::ipaddress}:4001"
  }

  docker::run { 'shipyard-swarm-agent':
    image   => 'swarm:latest',
    command => "join --addr ${::ipaddress}:2375 etcd://${::ipaddress}:4001"
  }

  docker::run { 'shipyard-controller':
    image   => 'shipyard/shipyard:latest',
    ports   => [ '8001:8080' ],
    links   => [ 
      'shipyard-rethinkdb:rethinkdb',
      'shipyard-swarm-manager:swarm'
    ],
    command => 'server -d tcp://swarm:3375'
  }

}