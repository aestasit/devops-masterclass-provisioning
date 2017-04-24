
class setup::elk {

  Package {
    allow_virtual => false,
  }

  apt::source { 'elasticsearch':
    location => 'https://artifacts.elastic.co/packages/2.x/apt',
    release  => 'stable',
    repos    => 'main',
    key      => {
      'id'     => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
      'source' => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
    },
    include  => {
      'src' => false,
      'deb' => true,
    }
  }

  class { 'elasticsearch':
    restart_on_change => true,
    manage_repo       => false,
    autoupgrade       => true,
    purge_package_dir => true,
    require           => [
      Package['wget'],
      Apt::Source['elasticsearch']
    ]
  }

  if (!defined(Package['wget'])) {
    package { 'wget':
      ensure => latest
    }
  }

  elasticsearch::instance { "elasticsearch": 
    config            => {
      'cluster.name'                         => 'ExtremeCluster',
      'path.data'                            => '/var/lib/elasticsearch/data',
      'path.logs'                            => '/var/log/elasticsearch',
      'path.work'                            => '/var/lib/elasticsearch/work',
      'indices.memory.index_buffer_size'     => '50%',
      'index.translog.flush_threshold_ops'   => '50000',
      'threadpool.search.type'               => 'fixed',
      'threadpool.search.size'               => '20',
      'threadpool.search.queue_size'         => '100',
      'threadpool.index.type'                => 'fixed',
      'threadpool.index.size'                => '60',
      'threadpool.index.queue_size'          => '200',
      'bootstrap.mlockall'                   => 'true',
      'discovery.zen.fd.ping_timeout'        => '10s',
      'discovery.zen.ping.multicast.enabled' => 'false',
      'discovery.zen.ping.unicast.hosts'     => $ipaddress,
      'marvel.agent.enabled'                 => 'false',
    },
    init_defaults     => {
      'ES_JAVA_OPTS'                         => '"-Xmx2048m -XX:+UseTLAB -XX:+CMSClassUnloadingEnabled"',
    },
  }

  file { [
    '/var/lib/elasticsearch', 
    '/var/lib/elasticsearch/data', 
    '/var/lib/elasticsearch/work',
    '/var/lib/elasticsearch/templates' 
  ]:
    ensure  => directory,
    owner   => 'elasticsearch',
    group   => 'elasticsearch',
    require => [
      Package['elasticsearch']
    ]
  }

  $logstash_config = {
    'JAVA_HOME'      => '/usr',
    'JAVACMD'        => '/usr/bin/java',
    'START'          => 'true',
    'LS_OPEN_FILES'  => '16384',
    'LS_HEAP_SIZE'   => '"2048m"',
    'LS_USER'        => 'root',
    'LS_GROUP'       => 'root',
    'FILTER_THREADS' => '2',
  }

  class { 'logstash':
    restart_on_change => true,
    status            => unmanaged,
    autoupgrade       => true,
    manage_repo       => true,
    init_defaults     => $logstash_config,
    require           => [
      Class['elasticsearch'],
      Apt::Source['elasticsearch']
    ]
  }

  logstash::configfile { 'input_filebeat':
    content           => template('setup/logstash/input_filebeat.conf.erb'),
    order             => 10
  }

  logstash::configfile { 'log_filters':
    content           => template('setup/logstash/log_filters.conf.erb'),
    order             => 80
  }

  logstash::configfile { 'output_elasticsearch':
    content           => template('setup/logstash/output_elasticsearch.conf.erb'),
    order             => 90
  }
  
  file {'/var/log/logstash':
    ensure  => directory,
    owner   => 'logstash',
    group   => 'logstash',
    require => [
      Class['logstash'],
    ]
  }

  archive { "/tmp/kibana-5.3.0-linux-x86_64.tar.gz":
    ensure        => present,
    extract       => true,
    extract_path  => '/opt/kibana',
    source        => "https://artifacts.elastic.co/downloads/kibana/kibana-5.3.0-linux-x86_64.tar.gz",
    checksum      => '4e9daf275f8ef749fba931c1f5c35f85662efd53',
    checksum_type => 'sha1',
    creates       => '/opt/kibana/kibana-5.3.0-linux-x86_64',
    cleanup       => true,
  }

  file { '/etc/init.d/kibana':
    content          => template('setup/kibana.erb'),
    owner            => 'root',
    group            => 'root',
    mode             => '0755',
#    before           => Service['kibana'],
#    notify           => Service['kibana']  
  }

#  exec { 'wait for elasticsearch':
#     command     => 'sleep 300',
#     path        => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ], 
#     refreshonly => true,
#     timeout     => 310,
#     subscribe   => Service['elasticsearch-instance-elasticsearch']
#   }

#   service { 'kibana':
#     ensure      => running,
#     enable      => true,
#     require     => [
#       File['/etc/init.d/kibana'],
#       Service['elasticsearch-instance-elasticsearch'],
#       Exec['wait for elasticsearch']
#     ]
#   }

}