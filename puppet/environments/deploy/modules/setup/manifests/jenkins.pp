
class setup::jenkins(
  $jenkins_version = '2.46.2'
) {

  contain '::setup::java'

  $jenkins_package = "https://pkg.jenkins.io/debian-stable/binary/jenkins_${jenkins_version}_all.deb"

  archive { "/tmp/jenkins_${jenkins_version}_all.deb":
    ensure           => present,
    source           => $jenkins_package,
    extract          => false,
    cleanup          => false
  }

  package { [ 'openjdk-7-jre-headless', 'daemon' ]:
    ensure          => installed,
    before          => Class['::setup::java'],
    require         => Exec['apt_update']
  }
  
  exec { 'jenkins':
    unless          => "dpkg -s jenkins",
    command         => "/usr/bin/dpkg -i /tmp/jenkins_${jenkins_version}_all.deb",
    notify          => Service['jenkins'],
    require         => [
      Archive["/tmp/jenkins_${jenkins_version}_all.deb"],
      Package['daemon'],
      Package['openjdk-7-jre-headless'],
      Class['::setup::java'],
      Exec['apt_update']
    ]
  }

  file { '/etc/default/jenkins':
    content => template('setup/jenkins.default.erb'),
    require => Exec['jenkins'],
    notify  => Service['jenkins']
  }

  file { '/var/lib/jenkins/config.xml':
    content => template('setup/config.xml.erb'),
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
    require => Exec['jenkins'],
  }

  user { 'jenkins':
    ensure     => present,
    require    => Exec['jenkins'],
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

  nginx::resource::server { 'jenkins.extremeautomation.io':
    listen_port => 80,
    proxy       => 'http://localhost:8800',
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
