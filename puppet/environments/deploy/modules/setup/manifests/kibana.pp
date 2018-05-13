
class setup::kibana(
  $kibana_version = '6.2.4'
) {

  docker::image { 'docker.elastic.co/kibana/kibana-oss':
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
    image            => "docker.elastic.co/kibana/kibana-oss:${kibana_version}",
    net              => 'elastic-net',
    ports            => [
      '5601:5601'
    ],
    restart_service  => true,
    volumes          => [ '/etc/kibana:/opt/kibana/config' ],
    links            => [ 'elasticsearch' ],
    extra_parameters => [
      '--restart=always'
    ],
  }

  nginx::resource::server { "kibana.extremeautomation.io":
    listen_port         => 80,
    location_cfg_append => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
  }

  nginx::resource::server { 'kibana.extremeautomation.io kibana':
    listen_port => 443,
    ssl         => true,
    ssl_cert    => '/etc/letsencrypt/live/extremeautomation.io/fullchain.pem',
    ssl_key     => '/etc/letsencrypt/live/extremeautomation.io/privkey.pem',
    ssl_port    => 443,
    proxy       => 'http://localhost:5601',
  }

}