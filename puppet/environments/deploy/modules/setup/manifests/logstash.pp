
class setup::logstash(
  $logstash_version = '6.2.4'
) {

  docker::image { 'docker.elastic.co/logstash/logstash-oss':
    image_tag        => $logstash_version
  }

  file { '/etc/logstash':
    ensure           => directory
  }

  file { '/etc/logstash/logstash.conf':
    content          => template('setup/logstash.conf.erb'),
    notify           => Docker::Run['logstash']
  }

  file { '/etc/logstash/logstash.yml':
    content          => template('setup/logstash.yml.erb'),
    notify           => Docker::Run['logstash']
  }

  docker::run { 'logstash':
    image            => "docker.elastic.co/logstash/logstash-oss:${logstash_version}",
    net              => 'elastic-net',
    restart_service  => true,
    volumes          => [
      '/etc/logstash/logstash.conf:/usr/share/logstash/pipeline/logstash.conf',
      '/etc/logstash/logstash.yml:/usr/share/logstash/config/logstash.yml',
    ],
    links            => [ 'elasticsearch' ],
    extra_parameters => [
      '--restart=always'
    ],
  }

}
