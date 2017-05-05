
class setup {

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

  include setup::common

  include setup::docker
  include setup::java

  include setup::jenkins
  include setup::gitlab

  include setup::elasticsearch
  include setup::logstash
  include setup::kibana
  include setup::beats

  include setup::vault
  include setup::sysdig

  include setup::swarm
  include setup::rancher
  include setup::kubernetes

}