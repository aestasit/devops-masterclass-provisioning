
class setup::grafana (
  $grafana_version = "4.2.0"
) {

  docker::run { 'grafana':
    image            => "grafana/grafana:${grafana_version}",
    ports            => [ '8300:3000' ],
    restart_service  => true,
    extra_parameters => [
      '--restart=always',
    ],
  }

  nginx::resource::server { 'grafana.extremeautomation.io':
    listen_port => 80,
    proxy       => 'http://localhost:8300',
  }

}
