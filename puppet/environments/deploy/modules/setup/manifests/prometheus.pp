
class setup::prometheus (

) {

  file { '/etc/prometheus':
    ensure           => directory
  }

  file { '/etc/prometheus/prometheus.yml':
    ensure           => file,
    content          => template('setup/prometheus.yml.erb'),
    notify           => Docker::Run['prometheus']
  }

  docker::run { 'prometheus':
    image            => 'prom/prometheus:v1.6.1',
    ports            => [ '9090:9090' ],
    volumes          => [ '/etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml' ],
    restart_service  => true,
    extra_parameters => [
      '--restart=always',
    ],
    require          => [
      File['/etc/prometheus/prometheus.yml']
    ]
  }

}
