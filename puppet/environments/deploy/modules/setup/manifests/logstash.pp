

class setup::logstash(
  $logstash_version = '5.3.1'
) {

  docker::image { 'docker.elastic.co/logstash/logstash':
    image_tag        => $logstash_version
  }

  file { '/etc/logstash':
    ensure           => directory
  }

  docker::run { 'logstash':
    image            => "docker.elastic.co/logstash/logstash:$logstash_version",
    net              => 'host',
    restart_service  => true,
    volumes          => [ '/etc/logstash:/opt/logstash/config' ],
    extra_parameters => [
      '--restart=always',
      '--add-host elasticsearch:127.0.0.1'
    ],
  }

  # TODO: configure pipeline for beats server and syslog

}
