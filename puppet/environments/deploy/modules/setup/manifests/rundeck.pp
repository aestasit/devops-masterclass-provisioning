
class setup::rundeck {

  class { 'rundeck':
    grails_server_url => "http://rundeck.extremeautomation.io"
  }

  nginx::resource::server { 'rundeck.extremeautomation.io':
    listen_port => 80,
    proxy       => 'http://localhost:4440',
    server_cfg_append    => {
      'client_max_body_size' => '100m',
    }
  }

}