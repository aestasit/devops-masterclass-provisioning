
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

  docker::run { 'kibana':
    image            => "docker.elastic.co/kibana/kibana:$kibana_version",
    net              => 'host',
    ports            => [ '5601:5601' ],
    restart_service  => true,
    volumes          => [ '/etc/kibana:/opt/kibana/config' ],
    command          => "/bin/sh -c 'kibana-plugin remove x-pack && /usr/local/bin/kibana-docker'",
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