
class setup::elasticsearch(
  $elasticsearch_version = '6.2.4'
) {

  docker_network { 'elastic-net':
    ensure   => present,
  }

  sysctl::configuration { 'vm.max_map_count':
    value => '262144'
  }

  docker::run { 'elasticsearch':
    image            => "docker.elastic.co/elasticsearch/elasticsearch-oss:${elasticsearch_version}",
    net              => 'elastic-net',
    ports            => [
      '9200:9200',
      '9300:9300',
    ],
    restart_service  => true,
    env              => [
      "cluster.name=docker-cluster",
      "bootstrap.memory_lock=false",
      "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ],
    volumes          => [
      'esdata1:/usr/share/elasticsearch/data'
    ],
    extra_parameters => [
       '--restart=always',
       '--ulimit memlock=-1:-1'
    ],
  }

}
