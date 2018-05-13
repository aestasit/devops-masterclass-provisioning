class setup::bamboo {

  class { '::bamboo':
    version      => '6.3.1',
    tomcat_port  => '9697',
    installdir   => '/opt/bamboo',
    homedir      => '/var/local/bamboo',
    java_home    => '/usr/',
    user         => 'bamboo',
  }

  nginx::resource::server { "bamboo.extremeautomation.io":
    listen_port         => 80,
    location_cfg_append => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
  }

  nginx::resource::server { 'bamboo.extremeautomation.io bamboo':
    listen_port => 443,
    ssl         => true,
    ssl_cert    => '/etc/letsencrypt/live/extremeautomation.io/fullchain.pem',
    ssl_key     => '/etc/letsencrypt/live/extremeautomation.io/privkey.pem',
    ssl_port    => 443,
    proxy       => 'http://localhost:9697',
  }

}