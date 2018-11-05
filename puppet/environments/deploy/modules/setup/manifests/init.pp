
class setup {

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

  include nginx

  include setup::common

  include setup::docker
  include setup::java
  include setup::python

  include setup::jenkins
  include setup::gitlab

  # include setup::bamboo
  # include setup::bitbucket

  include setup::consul

  include setup::elasticsearch
  include setup::logstash
  include setup::kibana
  include setup::beats

  # include setup::rancher

  # include setup::concourse
  # include setup::rundeck

  # include setup::sysdig
  # include setup::grafana
  # include setup::prometheus

  # include setup::vault

  # include setup::artifactory

}