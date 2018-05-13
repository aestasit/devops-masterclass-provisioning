
class setup::bitbucket {

  class { '::bitbucket':
    version      => '5.7.0',
    javahome     => '/usr/',
    dburl        => 'jdbc:h2:file:/home/bitbucket/db',
    dbdriver     => 'org.h2.Driver',
    tomcat_port  => '7991'
  }

  nginx::resource::server { "bitbucket.extremeautomation.io":
    listen_port         => 80,
    location_cfg_append => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
  }

  nginx::resource::server { 'bitbucket.extremeautomation.io bitbucket':
    listen_port => 443,
    ssl         => true,
    ssl_cert    => '/etc/letsencrypt/live/extremeautomation.io/fullchain.pem',
    ssl_key     => '/etc/letsencrypt/live/extremeautomation.io/privkey.pem',
    ssl_port    => 443,
    proxy       => 'http://localhost:7991',
  }

}