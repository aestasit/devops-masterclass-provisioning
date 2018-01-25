
class setup::bitbucket {

  class { '::bitbucket':
    version      => '5.7.0',
    javahome     => '/usr/',
    dburl        => 'jdbc:h2:file:/home/bitbucket/db',
    dbdriver     => 'org.h2.Driver',
    tomcat_port  => '7991'
  }

  nginx::resource::server { 'bitbucket.extremeautomation.io':
    listen_port => 80,
    proxy       => 'http://localhost:7991',
  }

}