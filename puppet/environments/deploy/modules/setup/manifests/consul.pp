
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

  nginx::resource::server { 'consul.extremeautomation.io':
    listen_port => 80,
    proxy       => 'http://localhost:8500',
  }

}