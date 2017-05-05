
class setup::rancher(

) {

  #
  # TODO:
  #
  # docker::run { $db_container:
  #   image   => 'mariadb',
  #   env     => [
  #     "MYSQL_ROOT_PASSWORD=${db_password}",
  #     "MYSQL_USER=${db_user}",
  #     "MYSQL_PASSWORD=${db_password}",
  #     "MYSQL_DATABASE=${db_name}",
  #   ],
  #   volumes => [ "/var/lib/${db_container}:/var/lib/mysql" ],
  #   notify  => Docker::Run[$container_name],
  # }

  # TODO: docker run -d --restart=unless-stopped -p 8080:8080 rancher/server --db-host myhost.example.com --db-port 3306 --db-user username --db-pass password --db-name cattle

}