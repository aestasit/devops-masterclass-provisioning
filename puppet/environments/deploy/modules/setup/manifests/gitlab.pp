
class setup::gitlab(

) {

  #
  # TODO: implement
  #
  # class { 'gitlab':
  #   external_url => 'http://gitlab.extremeautmation.io',
  # }
  #

  nginx::resource::server { 'gitlab.extremeautomation.io':
    listen_port => 80,
    proxy       => 'http://localhost:8081',
  }

}