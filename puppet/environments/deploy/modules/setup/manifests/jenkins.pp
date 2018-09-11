
class setup::jenkins(
  $jenkins_version = '2.124',
  $jenkins_admin_user = 'root',
  $jenkins_admin_password = 'DevOps2018',
  $jenkins_dir = "/var/lib/jenkins",
  $jenkins_plugins_dir = "${jenkins_dir}/plugins",
  $jenkins_jobs_dir = "${jenkins_dir}/jobs",
  $jenkins_scripts_dir = "${jenkins_dir}/scripts",
) {

  contain '::setup::java'

  $jenkins_package = "https://pkg.jenkins.io/debian/binary/jenkins_${jenkins_version}_all.deb"

  archive { "/tmp/jenkins_${jenkins_version}_all.deb":
    ensure           => present,
    source           => $jenkins_package,
    extract          => false,
    cleanup          => false
  }

  apt::ppa { 'ppa:jonathonf/openjdk': }

  package { [ 'openjdk-8-jdk', 'daemon' ]:  # TODO: we do not need this package in fact, it's only to satisfy apt-get/dpkg; actual java is setup by setup::java class
    ensure          => installed,
    before          => Class['::setup::java'],
    require         => [
      Apt::Ppa['ppa:jonathonf/openjdk'],
      Exec['apt_update']
    ]
  }

  exec { 'jenkins':
    unless          => "dpkg -s jenkins | grep 'Version: ${jenkins_version}'",
    command         => "/usr/bin/dpkg --force-all -i /tmp/jenkins_${jenkins_version}_all.deb",
    notify          => Service['jenkins'],
    require         => [
      Archive["/tmp/jenkins_${jenkins_version}_all.deb"],
      Package['daemon'],
      Package['openjdk-8-jdk'],
      Class['::setup::java'],
      Exec['apt_update']
    ]
  }

  $jenkins_cli_jar = "${jenkins_lib_dir}/jenkins-cli.jar"

  $jenkins_script_environment = [
    "JENKINS_HOST=http://127.0.0.1:8800",
    "JENKINS_USER=${jenkins_admin_user}",
    "JENKINS_PASSWORD=${jenkins_admin_password}",
  ]

  file { '/etc/default/jenkins':
    content => template('setup/jenkins.default.erb'),
    require => Exec['jenkins'],
    notify  => Service['jenkins']
  }

  file { '/var/lib/jenkins/secrets':
    ensure  => directory,
    owner   => 'jenkins',
    group   => 'jenkins',
    require => Exec['jenkins'],
    notify  => Service['jenkins']
  }

  file { '/var/lib/jenkins/secrets/slave-to-master-security-kill-switch':
    content => 'false',
    mode    => '0644',
    owner   => 'jenkins',
    group   => 'jenkins',
    require => Exec['jenkins'],
    notify  => Service['jenkins']
  }

  file { '/var/lib/jenkins/jenkins.CLI.xml':
    content => template('setup/jenkins.CLI.xml.erb'),
    require => Exec['jenkins'],
    notify  => Service['jenkins']
  }

  file { '/var/lib/jenkins/secrets/initialAdminPassword':
    ensure  => absent,
    notify  => Service['jenkins']
  }

  file { '/var/lib/jenkins/jenkins.install.InstallUtil.lastExecVersion':
    ensure  => present,
    content => $jenkins_version,
    notify  => Service['jenkins']
  }

  service { 'jenkins':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    require    => Exec['jenkins']
  }

  group { 'jenkins':
    ensure  => present,
    # require => Exec['jenkins'],
  }

  user { 'jenkins':
    ensure     => present,
    # require    => Exec['jenkins'],
  }

  setup::jenkins::plugin { [
    'credentials',
    'active-directory',
    'blueocean',
    'timestamper',
    'ansicolor',
    'ldap',
    'git',
    'matrix-auth',
    'workflow-aggregator',
    'docker-workflow',
    'greenballs',
    'ssh-slaves',
    'bitbucket',
    'email-ext',
    'naginator',
    'groovy-postbuild',
    'mask-passwords',
    'view-job-filters',
    'dashboard-view',
    'sectioned-view',
    'categorized-view',
    'rebuild',
    'envinject',
    'build-timeout',
    'next-executions',
    'warnings',
    'tasks',
    'dependency-check-jenkins-plugin',
    'extensible-choice-parameter',
    'PrioritySorter',
    'throttle-concurrents',
    'project-stats-plugin',
    'subversion',
    'ws-cleanup',
    'purge-build-queue-plugin',
    'cucumber-reports',
    'cucumber-testresult-plugin',
    'disk-usage',
    'shelve-project-plugin',
    'simple-theme-plugin'
  ]:
  }

  file { [
    $jenkins_dir,
    $jenkins_plugins_dir,
    $jenkins_jobs_dir
  ]:
    ensure => directory,
    owner  => 'jenkins',
    group  => 'jenkins',
    mode   => '0755',
    # before => Exec['jenkins'],
    # require => [
    #   Group['jenkins'],
    #   User['jenkins']
    # ],
  }

  file { [ $jenkins_scripts_dir ]:
    ensure  => directory,
    recurse => true,
    purge   => true,
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => '0755',
    before  => Exec['jenkins']
  }

  file { "${jenkins_scripts_dir}/jenkins_plugin.sh":
    ensure => file,
    owner  => 'jenkins',
    group  => 'jenkins',
    mode   => '0744',
    source => "puppet:///modules/${module_name}/scripts/jenkins_plugin.sh"
  }

  file { "${jenkins_scripts_dir}/jenkins_script.sh":
    ensure => file,
    owner  => 'jenkins',
    group  => 'jenkins',
    mode   => '0744',
    source => "puppet:///modules/${module_name}/scripts/jenkins_script.sh"
  }

  exec { 'wait-for-start':
    command   => "curl -o /dev/null --silent --head --max-time 30 --write-out '%{http_code}\\n' http://127.0.0.1:8800/cli/ | egrep '200|403'",
    unless    => "curl -o /dev/null --silent --head --max-time 30 --write-out '%{http_code}\\n' http://127.0.0.1:8800/cli/ | egrep '200|403'",
    tries     => 10,
    try_sleep => 10,
    subscribe => Service['jenkins']
  }

  exec { 'force-restart':
    command     => "service jenkins restart",
    refreshonly => true
  }

  augeas { 'configure-security':
    incl    => "${jenkins_dir}/config.xml",
    context => "/files/var/lib/jenkins/config.xml/hudson",
    lens    => 'Xml.lns',
    changes => [
      'set useSecurity/#text true',
#     'set disabledAdministrativeMonitors/string[#text="jenkins.security.s2m.MasterKillSwitchWarning"]/#text jenkins.security.s2m.MasterKillSwitchWarning',
    ],
    require => Exec['wait-for-start'],
    notify  => Setup::Jenkins::Script['reload_configuration']
  }

  setup::jenkins::script { 'configure_base_security':
    script_template => 'basic_security.groovy',
    args            => {
      jenkins_admin_username => "${jenkins_admin_user}",
      jenkins_admin_password => "${jenkins_admin_password}",
    }
  }

  setup::jenkins::script { 'reload_configuration':
    script_template => 'reload.groovy',
    require         => Setup::Jenkins::Script['configure_base_security'],
    refreshonly     => true
  }

  Setup::Jenkins::Script { 'configure_csrf':
    script_template => 'configure_csrf.groovy',
    require         => Setup::Jenkins::Script['configure_base_security'],
  }

  Setup::Jenkins::Script { 'configure_jlnp_protocols':
    script_template => 'configure_jlnp_protocols.groovy',
    require         => Setup::Jenkins::Script['configure_base_security'],
  }

  Setup::Jenkins::Script { 'disable_usage_stats':
    script_template => 'disable_usage_stats.groovy',
    require         => Setup::Jenkins::Script['configure_base_security'],
  }

  Setup::Jenkins::Script { 'configure_executors':
    script_template => 'configure_executors.groovy',
    require         => Setup::Jenkins::Script['configure_base_security'],
  }

  Setup::Jenkins::Script { 'set_master_labels':
    script_template => 'set_master_labels.groovy',
    require         => Setup::Jenkins::Script['configure_base_security'],
  }

  nginx::resource::server { "jenkins.extremeautomation.io":
    listen_port         => 80,
    location_cfg_append => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
  }

  nginx::resource::server { 'jenkins.extremeautomation.io jenkins':
    listen_port => 443,
    ssl         => true,
    ssl_cert    => '/etc/letsencrypt/live/extremeautomation.io/fullchain.pem',
    ssl_key     => '/etc/letsencrypt/live/extremeautomation.io/privkey.pem',
    ssl_port    => 443,
    proxy       => 'http://localhost:8800',
  }

}


define setup::jenkins::plugin {

  exec { "Install Jenkins plugin ${name}":
    environment => $::setup::jenkins::jenkins_script_environment,
    command     => "/bin/bash -x ${::setup::jenkins::jenkins_scripts_dir}/jenkins_plugin.sh ${name}",
    unless      => "test -f ${::setup::jenkins::jenkins_plugins_dir}/${name}.jpi -o -f ${::setup::jenkins::jenkins_plugins_dir}/${name}.hpi",
    logoutput   => on_failure,
    require     => [
      Exec['wait-for-start'],
      File["${::setup::jenkins::jenkins_scripts_dir}/jenkins_plugin.sh"],
    ],
    notify      => Exec['force-restart']
  }

}

define setup::jenkins::script(
  $script_template,
  $args        = {},
  $unless      = undef,
  $logoutput   = true,
  $refreshonly = undef
) {

  $script_name = base64('encode', $name, 'urlsafe')
  $script = "${::setup::jenkins::jenkins_scripts_dir}/${script_name}.groovy"

  file { $script:
    content => template("${module_name}/${script_template}.erb"),
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => '0600'
  }

  exec { "Execute script ${name}":
    environment => $::setup::jenkins::jenkins_script_environment,
    command     => "/bin/bash ${::setup::jenkins::jenkins_scripts_dir}/jenkins_script.sh ${script}",
    logoutput   => $logoutput,
    refreshonly => $refreshonly,
    unless      => $unless,
    require     => [
      Exec['wait-for-start'],
      File["${::setup::jenkins::jenkins_scripts_dir}/jenkins_script.sh"],
      File[$script],
    ]
  }

}