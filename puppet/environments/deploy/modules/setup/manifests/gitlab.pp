
class setup::gitlab(
  $gitlab_version = '9.1.2-ce.0',
  $gitlab_password = 'OrangE2017'
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
    env              => [
      "GITLAB_OMNIBUS_CONFIG=\"external_url 'http://gitlab.extremeautomation.io/'; gitlab_rails['initial_root_password'] = '${gitlab_password}'; gitlab_rails['rack_attack_git_basic_auth'] = { 'enabled' => false };\""
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
    server_cfg_append    => {
      'client_max_body_size' => '100m',
    }
  }

}