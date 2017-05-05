
class setup::kibana(
  $kibana_version = '5.3.1'
) {

  docker::image { 'docker.elastic.co/kibana/kibana':
    image_tag        => $kibana_version
  }

  file { '/etc/kibana':
    ensure           => directory
  }

  file { '/etc/kibana/kibana.yml':
    ensure           => file,
    content          => template('setup/kibana.yml.erb'),
    notify           => Docker::Run['kibana']
  }

  docker::run { 'kibana':
    image            => "docker.elastic.co/kibana/kibana:$kibana_version",
    net              => 'host',
    ports            => [ '5601:5601' ],
    restart_service  => true,
    volumes          => [ '/etc/kibana:/opt/kibana/config' ],
    command          => "/bin/sh -c 'kibana-plugin remove x-pack && /usr/local/bin/kibana-docker'",
    extra_parameters => [
      '--restart=always',
      '--add-host elasticsearch:127.0.0.1'
    ],
  }

  nginx::resource::server { 'kibana.extremeautomation.io':
    listen_port => 80,
    proxy       => 'http://localhost:5601',
  }

  # TODO: add index templates

  # TODO: add dashboards

#
#   # Run a short-lived container to import the default dashboards for the Beats.
#   import_dashboards:
#   # Any Beats image will do. We'll use Metricbeat.
#   image: docker.elastic.co/beats/metricbeat:$ELASTIC_VERSION
#   networks: ['stack']
#   command: >-
#     /usr/share/metricbeat/scripts/import_dashboards
#   -beat ""
#     -file /usr/share/metricbeat/beats-dashboards-$ELASTIC_VERSION.zip
#     -es http://elasticsearch:9200
#     -user elastic
#   -pass changeme
#   depends_on: {kibana: {condition: service_healthy}}
#
# # Another short-lived container to create a Kibana index pattern for Logstash.
# create_logstash_index_pattern:
# # The image just needs curl, and we know that Metricbeat has that.
# image: docker.elastic.co/beats/metricbeat:$ELASTIC_VERSION
# networks: ['stack']
# # There's currently no API for creating index patterns, so this is a bit hackish.
# command: >-
#   curl -XPUT http://elastic:changeme@elasticsearch:9200/.kibana/index-pattern/logstash-*
#   -d '{"title" : "logstash-*",  "timeFieldName": "@timestamp"}'
# depends_on: {kibana: {condition: service_healthy}}
#
# set_default_index_pattern:
# image: docker.elastic.co/beats/metricbeat:$ELASTIC_VERSION
# networks: ['stack']
# command: >-
#   curl -XPUT http://elasticsearch:9200/.kibana/config/$ELASTIC_VERSION -d '{"defaultIndex" : "metricbeat-*"}'
# depends_on: {kibana: {condition: service_healthy}}

}