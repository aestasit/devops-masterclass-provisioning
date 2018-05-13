
class setup::consul {

  class { '::consul':
    version => '1.0.3',
    config_hash => {
      'bootstrap_expect' => 1,
      'client_addr'      => '0.0.0.0',
      'bind_addr'        => '127.0.0.1',
      'data_dir'         => '/opt/consul',
      'datacenter'       => 'xa',
      'log_level'        => 'INFO',
      'node_name'        => 'server',
      'server'           => true,
      'ui'               => true,
      'ports'            => {
        'http'           => 8500,
        'server'         => 8300
      }
    }
  }

  nginx::resource::server { "consul.extremeautomation.io":
    listen_port         => 80,
    location_cfg_append => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
  }

  nginx::resource::server { 'consul.extremeautomation.io consul':
    listen_port => 443,
    ssl         => true,
    ssl_cert    => '/etc/letsencrypt/live/extremeautomation.io/fullchain.pem',
    ssl_key     => '/etc/letsencrypt/live/extremeautomation.io/privkey.pem',
    ssl_port    => 443,
    proxy       => 'http://localhost:8500',
  }

}