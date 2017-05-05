
class setup::rancher(
  $db_name = 'catle',
  $db_user = 'admin',
  $db_password = 'admin',
) {

  docker_network { 'rancher_net':
    ensure   => present,
  }

  file { '/var/lib/rancher_db':
    ensure => directory
  }

  file { '/var/lib/rancher':
    ensure => directory
  }

  docker::run { 'rancher-db':
    image            => 'mariadb:10.1.23',
    net              => 'rancher_net',
    env              => [
      "MYSQL_ROOT_PASSWORD=${db_password}",
      "MYSQL_USER=${db_user}",
      "MYSQL_PASSWORD=${db_password}",
      "MYSQL_DATABASE=${db_name}",
    ],
    restart_service  => true,
    volumes          => [ "/var/lib/rancher_db:/var/lib/mysql" ],
    notify           => Docker::Run["rancher"],
    extra_parameters => [
      '--restart=always',
    ],
    require          => [
      Docker_network["rancher_net"]
    ]
  }

  docker::run { 'rancher':
    image            => 'rancher/server:v1.6.0',
    net              => 'rancher_net',
    ports            => [ '8088:8080' ],
    restart_service  => true,
    command          => "--db-host rancher-db --db-port 3306 --db-user ${db_user} --db-pass ${db_password} --db-name ${db_name}",
    extra_parameters => [
      '--restart=always',
    ],
    require          => [
      Docker_network["rancher_net"]
    ]
  }

  nginx::resource::server { 'rancher.extremeautomation.io':
    listen_port => 80,
    proxy       => 'http://localhost:8088',
  }

}