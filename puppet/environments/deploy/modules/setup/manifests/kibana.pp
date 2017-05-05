
class setup::kibana {

  # TODO: launch kibana through docker

  # TODO: add virtual host

  #
  #  archive { "/tmp/kibana-5.3.0-linux-x86_64.tar.gz":
  #     ensure        => present,
  #     extract       => true,
  #     extract_path  => '/opt/kibana',
  #     source        => "https://artifacts.elastic.co/downloads/kibana/kibana-5.3.0-linux-x86_64.tar.gz",
  #     checksum      => '4e9daf275f8ef749fba931c1f5c35f85662efd53',
  #     checksum_type => 'sha1',
  #     creates       => '/opt/kibana/kibana-5.3.0-linux-x86_64',
  #     cleanup       => true,
  #   }
  #
  #   file { '/etc/init.d/kibana':
  #     content          => template('setup/kibana.erb'),
  #     owner            => 'root',
  #     group            => 'root',
  #     mode             => '0755',
  #     before           => Service['kibana'],
  #     notify           => Service['kibana']
  #   }

  #  exec { 'wait for elasticsearch':
  #     command     => 'sleep 300',
  #     path        => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
  #     refreshonly => true,
  #     timeout     => 310,
  #     subscribe   => Service['elasticsearch-instance-elasticsearch']
  #   }

  #   service { 'kibana':
  #     ensure      => running,
  #     enable      => true,
  #     require     => [
  #       File['/etc/init.d/kibana'],
  #       Service['elasticsearch-instance-elasticsearch'],
  #       Exec['wait for elasticsearch']
  #     ]
  #   }

}