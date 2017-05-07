
class setup::elasticsearch(
  $elasticsearch_version = '5.3.1'
) {

  contain '::setup::java'

  if (!defined(Package['wget'])) {
    package { 'wget':
      ensure => latest
    }
  }

  apt::source { 'elasticsearch':
    location => 'https://artifacts.elastic.co/packages/5.x/apt',
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
    java_install      => false,
    repo_version      => '5.x',
    version           => $elasticsearch_version,
    restart_on_change => true,
    manage_repo       => false,
    autoupgrade       => true,
    purge_package_dir => true,
    require           => [
      Package['wget'],
      Apt::Source['elasticsearch'],
      Class['::setup::java'],
      Exec['apt_update']
    ],
  }

  elasticsearch::instance { "es-01":
    config            => {
      'cluster.name'                         => 'ExtremeCluster',
      'transport.host'                       => 'localhost',
      'transport.tcp.port'                   => 9300,
      'http.port'                            => 9200,
      'network.host'                         => '0.0.0.0'
    },
    init_defaults     => {
      'JAVA_HOME'                            => '/usr/lib/jvm/jdk1.8.0_111/',
      'ES_JAVA_OPTS'                         => '"-Xmx4096m -XX:+UseTLAB -XX:+CMSClassUnloadingEnabled"',
    },
    require           => [
      Class['::setup::java']
    ]
  }

}
