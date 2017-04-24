class setup::shipper (
  $log_indexer                = '127.0.0.1',
  $logstash_forwarder_crt     = 'puppet:///modules/setup/forwarder.crt',
) {

  Package {
    allow_virtual => false,
  }

  host { 'logstash.extremeautomation.com':
    ip => $log_indexer
  }

  class { 'logstashforwarder':
    ensure            => present,
    restart_on_change => true,
    servers           => [ 'logstash.extremeautomation.com:6782' ],
    # init_template     => 'setup/logstash-forwarder.erb',
    manage_repo       => true,
    ssl_ca            => $logstash_forwarder_crt,
  } 

  logstashforwarder::file { 'syslog':
    paths  => [ '/var/log/syslog' ],
    fields => { 'type' => 'syslog' },
  }

  logstashforwarder::file { 'jenkins':
    paths  => [ '/var/log/jenkins/jenkins.log' ],
    fields => { 'type' => 'jenkins-server' },
  }

}