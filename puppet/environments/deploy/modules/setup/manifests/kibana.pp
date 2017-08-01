
class setup::kibana(
  $kibana_version = '5.3.1'
) {

  docker::image { 'docker.elastic.co/kibana/kibana':
    image_tag        => $kibana_version
  }

  file { '/etc/kibana':
    ensure           => directory
  }

  file { '/etc/kibana/kibana.yml':
    ensure           => file,
    content          => template('setup/kibana.yml.erb'),
    notify           => Docker::Run['kibana']
  }

  $dockerfile = @("EOT")
     FROM docker.elastic.co/kibana/kibana:${kibana_version}
     RUN kibana-plugin remove x-pack
     | EOT

  file { '/tmp/kibana':
    ensure => directory
  }

  file { "/tmp/kibana/Dockerfile":
    content => $dockerfile
  }

  docker::image { 'kibana':
    image_tag   => 'local',
    docker_file => '/tmp/kibana/Dockerfile'
  }

  docker::run { 'kibana':
    image            => "kibana:local",
    net              => 'host',
    ports            => [ '5601:5601' ],
    restart_service  => true,
    volumes          => [ '/etc/kibana:/opt/kibana/config' ],
    command          => "/usr/local/bin/kibana-docker",
    require          => Docker::Image['kibana'],
    extra_parameters => [
      '--restart=always',
      '--add-host elasticsearch:127.0.0.1'
    ],
  }

  nginx::resource::server { 'kibana.extremeautomation.io':
    listen_port => 80,
    proxy       => 'http://localhost:5601',
  }

}