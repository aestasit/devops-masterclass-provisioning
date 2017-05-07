
class setup::docker {

  class { '::docker':
    package_name => 'docker-ce',
    use_upstream_package_source => false
  }

  # TODO; docker swarm

  #   $docker_swarm_init_flags = docker_swarm_init_flags({
#     init => $init,
#     advertise_addr => $advertise_addr,
#     autolock => $autolock,
#     cert_expiry => $cert_expiry,
#     dispatcher_heartbeat => $dispatcher_heartbeat,
#     external_ca => $external_ca,
#     force_new_cluster => $force_new_cluster,
#     listen_addr => $listen_addr,
#     max_snapshots => $max_snapshots,
#     snapshot_interval => $snapshot_interval,
#   })
#
#   $exec_init = "${docker_command} ${docker_swarm_init_flags}"
#   $unless_init = 'docker info | grep -w "Swarm: active"'
#
#   exec { 'Swarm init':
#     command     => $exec_init,
#     environment => 'HOME=/root',
#     path        => ['/bin', '/usr/bin'],
#     timeout     => 0,
#     unless      => $unless_init,
#   }
# }
#

  # TODO: docker registry

  # docker run -d -p 5000:5000 --restart=always --name registry \
  # -v `pwd`/data:/var/lib/registry \
  # registry:2
  #
  # docker run -d -p 5000:5000 --restart=always --name registry \
  # -v `pwd`/certs:/certs \
  # -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
  # -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
  # registry:2


  # TODO: add virtual host for registry??

}