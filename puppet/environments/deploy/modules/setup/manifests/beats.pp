
class setup::beats(
  $beats_version = '5.5.1'
) {

  #
  # Filebeat
  #

  $filebeat_package = "https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${beats_version}-amd64.deb"

  archive { "/tmp/filebeat-${beats_version}-amd64.deb":
    ensure           => present,
    source           => $filebeat_package,
    extract          => false,
    cleanup          => false
  }

  exec { 'filebeat':
    unless          => "dpkg -s filebeat",
    command         => "/usr/bin/dpkg -i /tmp/filebeat-${beats_version}-amd64.deb",
    notify          => Service['filebeat'],
    require         => [
      Archive["/tmp/filebeat-${beats_version}-amd64.deb"],
    ]
  }

  file { '/etc/filebeat/filebeat.yml':
    content         => template('setup/filebeat.yml.erb'),
    notify          => Service['filebeat'],
    require         => Exec['filebeat']
  }

  service { 'filebeat':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    require    => Exec['filebeat']
  }

  #
  # Metricbeat
  #

  $metricbeat_package = "https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-${beats_version}-amd64.deb"

  archive { "/tmp/metricbeat-${beats_version}-amd64.deb":
    ensure           => present,
    source           => $metricbeat_package,
    extract          => false,
    cleanup          => false
  }

  exec { 'metricbeat':
    unless          => "dpkg -s metricbeat",
    command         => "/usr/bin/dpkg -i /tmp/metricbeat-${beats_version}-amd64.deb",
    notify          => Service['metricbeat'],
    require         => [
      Archive["/tmp/metricbeat-${beats_version}-amd64.deb"],
    ]
  }

  service { 'metricbeat':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    require    => Exec['metricbeat']
  }

  file { '/etc/metricbeat/metricbeat.yml':
    content         => template('setup/metricbeat.yml.erb'),
    notify          => Service['metricbeat'],
    require         => Exec['metricbeat']
  }

  #
  # Packetbeat
  #

  $packetbeat_package = "https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-${beats_version}-amd64.deb"

  archive { "/tmp/packetbeat-${beats_version}-amd64.deb":
    ensure           => present,
    source           => $packetbeat_package,
    extract          => false,
    cleanup          => false
  }

  exec { 'packetbeat':
    unless          => "dpkg -s packetbeat",
    command         => "/usr/bin/dpkg -i /tmp/packetbeat-${beats_version}-amd64.deb",
    notify          => Service['packetbeat'],
    require         => [
      Archive["/tmp/packetbeat-${beats_version}-amd64.deb"],
    ]
  }

  service { 'packetbeat':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    require    => Exec['packetbeat']
  }

  file { '/etc/packetbeat/packetbeat.yml':
    content         => template('setup/packetbeat.yml.erb'),
    notify          => Service['packetbeat'],
    require         => Exec['packetbeat']
  }

}