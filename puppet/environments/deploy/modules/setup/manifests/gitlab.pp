
class setup::gitlab(
  $gitlab_version = '9.1.2-ce.0'
) {

  file { [
    '/var/lib/gitlab',
    '/var/lib/gitlab/config',
    '/var/lib/gitlab/logs',
    '/var/lib/gitlab/data',
  ]:
    ensure => directory
  }

  docker::run { 'gitlab':
    image            => "gitlab/gitlab-ce:${gitlab_version}",
    ports            => [
      '8443:443',
      '8480:80',
      '8422:22'
    ],
    restart_service  => true,
    volumes          => [
      '/var/lib/gitlab/config:/etc/gitlab',
      '/var/lib/gitlab/logs:/var/log/gitlab',
      '/var/lib/gitlab/data:/var/opt/gitlab',
    ],
    extra_parameters => [
      '--restart=always',
      '--hostname gitlab.extremeaution.io'
    ],
  }

  nginx::resource::server { 'gitlab.extremeautomation.io':
    listen_port => 80,
    proxy       => 'http://localhost:8480',
  }

}