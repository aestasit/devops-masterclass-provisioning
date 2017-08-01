
class setup::common(

) {

  package { [
    "zip",
    "curl",
    "wget",
    "build-essential",
    "tree",
    "links",
    "mc",
    "sysstat",
    "nmap",
    "whois"
  ]:
    ensure => latest
  }

  file { ['/var/www', '/var/www/default']:
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
  }

  file { '/var/www/default/index.htm':
    ensure  => file,
    content => '<html><body></body></html>',
    owner   => 'www-data',
    group   => 'www-data',
  }

  nginx::resource::server { "${ipaddress}":
    listen_port => 80,
    listen_options => 'default_server',
    www_root => '/var/www/default'
  }

}
