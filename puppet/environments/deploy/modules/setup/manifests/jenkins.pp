
class setup::jenkins {

  include git
  include apt

  class { 'groovy':
    version => '2.4.1'
  }

  vcsrepo { '/var/lib/bats':
    ensure   => present,
    provider => git,
    source   => 'git://github.com/sstephenson/bats.git',
    notify   => Exec['install bats']
  }

  package { 'python-dev':
    ensure => installed
  }

  package { 'python-pip':
    ensure => installed
  }

  package { 'paramiko':
    ensure => installed,
    provider => pip,
    require => [ Package['python-pip'], Package['python-dev'] ]
  }

  package { 'ecdsa':
    ensure => installed,
    provider => pip,
    require => [ Package['python-pip'], Package['python-dev'] ]
  }

  package { 'pycrypto':
    ensure => installed,
    provider => pip,
    require => [ Package['python-pip'], Package['python-dev'] ]
  }

  package { 'fabric':
    ensure => installed,
    provider => pip,
    require => [ Package['python-pip'], Package['pycrypto'], Package['python-dev'] ]
  }

  package { 'awscli':
    ensure => installed,
    provider => pip,
    require => Package['python-pip']
  }
                       
  $base_url         = 'https://releases.hashicorp.com/terraform'
  $target_dir       = '/usr/local/bin'
  $bin_name         = 'terraform'
  $_arch            = 'amd64'
  $_os              = 'linux'
  $_version         = '0.7.10'
  $archive_filename = "terraform_${_version}_${_os}_${_arch}"

  archive { "/tmp/${archive_filename}.zip":
    ensure        => present,
    extract       => true,
    extract_path  => '/usr/local/bin',
    source        => "${base_url}/${_version}/${archive_filename}.zip",
    checksum      => 'a6da76d6228349855f7c503b769fb231e6b1009add5e5b2586ecb7624e9ecf15',
    checksum_type => 'sha256',
    creates       => '/usr/local/bin/terraform',
    cleanup       => true,
  }

  exec { 'install bats':
    command     => '/var/lib/bats/install.sh /usr/local/bats',
    refreshonly => true
  }

  $jenkins_version = '2.46.1'                      
  $jenkins_package = "https://pkg.jenkins.io/debian-stable/binary/jenkins_${jenkins_version}_all.deb"

  archive { "/tmp/jenkins_${jenkins_version}_all.deb":
    ensure           => present,
    source           => $jenkins_package,
    extract          => false,
    cleanup          => false
  }

  package { [ 'openjdk-7-jre-headless', 'daemon' ]: 
    ensure          => installed,
    before          => Class['::setup::java'] 
  }

  package { 'jenkins':
    ensure          => latest,
    provider        => dpkg,
    source          => "/tmp/jenkins_${jenkins_version}_all.deb",
    notify          => Service['jenkins'],
    install_options => '--force-depends',
    require         => [ 
      Class['::setup::java'],
      Archive["/tmp/jenkins_${jenkins_version}_all.deb"],
      Package['daemon'],
      Package['openjdk-7-jre-headless'],
    ]
  }

  file { '/var/lib/jenkins/config.xml':
    content => template('setup/config.xml.erb'),
    require => Package['jenkins'],
    notify => Service['jenkins']
  }

  file { '/var/lib/jenkins/secrets/initialAdminPassword':
    ensure => absent,
    notify => Service['jenkins']
  }

  file { '/var/lib/jenkins/jenkins.install.InstallUtil.lastExecVersion':
    ensure => present,
    content => $jenkins_version,
    notify => Service['jenkins']
  }

  service { 'jenkins':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    require    => Package['jenkins']
  }

  group { 'jenkins':
    ensure  => present,
    require => Package['jenkins'],
  }

  user { 'jenkins':
    ensure     => present,
    require    => Package['jenkins'],
  }

  setup::jenkins::plugin {
    'git-client': ;
    'git': ;
    'plain-credentials': ;
    'tap': ;
    'scm-api': ;
    'structs': ;
    'multiple-scms': ;    
    'github-api': ;
    'github': ;
    'matrix-project': ;
    'jobConfigHistory': ;
    'token-macro': ;
    'timestamper': ;
    'javadoc': ;
    'slack': ;
    'jquery': ;
    'junit': ;
    'mailer': ;
    'script-security': ;
    'cloudbees-folder': ;
    'greenballs': ;
    'gradle': ;
    'groovy': ;
    'groovy-postbuild': ;
    'dashboard-view': ;
    'analysis-core': ;
    'maven-plugin': ;
    'ruby': ;
    'cobertura': ;
    'tasks': ;
    'htmlpublisher': ;
    'build-pipeline-plugin': ;
    'build-flow-plugin': ;
    'buildgraph-view': ;
    'build-timeout': ;
    'clone-workspace-scm': ;
    'join': ;
    'throttle-concurrents': ;
    'parameterized-trigger': ;
    'violations': ;
    'warnings': ;
    'build-name-setter': ;
    'nodelabelparameter': ;
    'ansicolor': ;
    'log-parser': ;
    'disk-usage': ;
    'next-executions': ;
    'global-build-stats': ;
    'project-stats-plugin': ;
    'show-build-parameters': ;
    'downstream-buildview': ;
    'envinject': ;
    'sectioned-view': ;
    'nested-view': ;
    'rebuild': ;
    'grails': ;
    'shelve-project-plugin': ;
    'extended-choice-parameter': ;
    'extensible-choice-parameter': ;
    'configurationslicing': ;
    'ssh-credentials': ;
    'credentials': ;
    'promoted-builds': ;    
    'conditional-buildstep': ;
    'display-url-api': ;
    'run-condition': ;
    'workflow-aggregator': ;
    'workflow-api': ;
    'workflow-basic-steps': ;
    'workflow-cps': ;
    'workflow-cps-global-lib': ;
    'workflow-durable-task-step': ;
    'workflow-job': ;
    'workflow-multibranch': ;
    'workflow-remote-loader': ;
    'workflow-scm-step': ;
    'workflow-step-api': ;
    'workflow-support': ;
    'pipeline-build-step': ;
    'pipeline-graph-analysis': ;
    'pipeline-input-step': ;
    'pipeline-maven': ;
    'pipeline-milestone-step': ;
    'pipeline-model-definition': ;
    'pipeline-model-api': ;
    'pipeline-model-extensions': ;
    'blueocean-pipeline-editor': ;
    'pipeline-model-declarative-agent': ;
    'pipeline-rest-api': ;
    'pipeline-stage-step': ;
    'pipeline-stage-view': ;
    'pipeline-utility-steps': ;
    'handlebars': ;
    'jquery-detached': ; 
    'momentjs': ;
    'durable-task': ;
    'docker-workflow': ;
    'ace-editor': ;
    'config-file-provider': ;
    'docker-commons': ;
    'credentials-binding': ;
    'pipeline-stage-tags-metadata': ;
    'git-server': ;
    'branch-api': ;
    'icon-shim': ;
    'authentication-tokens': ;
    'blueocean': ;
    'blueocean-rest': ;
    'blueocean-display-url': ;
    'blueocean-autofavorite': ;
    'blueocean-github-pipeline': ;
    'blueocean-pipeline-api-impl': ;
    'blueocean-i18n': ;
    'blueocean-rest-impl': ;
    'blueocean-git-pipeline': ;
    'blueocean-dashboard': ;
    'blueocean-config': ;
    'blueocean-web': ;
    'blueocean-commons': ;
    'blueocean-jwt': ;
    'blueocean-personalization': ;
    'metrics': ;
    'variant': ;
    'blueocean-events': ;
    'favorite': ;
    'jackson2-api': ;
    'github-branch-source': ;
    'github-organization-folder': ;
    'sse-gateway': ;
    'gitlab-plugin': ;
    'pipeline-github-lib':; 
    'pubsub-light':; 
  }

  file { [
    '/var/lib/jenkins',
    "/var/lib/jenkins/plugins"
  ]:
    ensure  => directory,
    owner   => 'jenkins',
    group   => 'jenkins',
    require => [
      Group['jenkins'],
      User['jenkins']
    ],
  }

}

define setup::jenkins::plugin($version=0) {

  if ($version != 0) {
    $base_url = "http://updates.jenkins-ci.org/download/plugins/${name}/${version}/"
  } else {
    $base_url = 'http://updates.jenkins-ci.org/latest/'
  }

  exec { "download jenkins plugin ${name}":
    command  => "wget --no-check-certificate ${base_url}${name}.hpi",
    cwd      => "/var/lib/jenkins/plugins",
    require  => File["/var/lib/jenkins/plugins"],
    path     => ['/usr/bin', '/usr/sbin',],
    user     => 'jenkins',
    unless   => "test -f /var/lib/jenkins/plugins/${name}.hpi -o -f /var/lib/jenkins/plugins/${name}.jpi",
    notify   => Service['jenkins'],
  }

}
