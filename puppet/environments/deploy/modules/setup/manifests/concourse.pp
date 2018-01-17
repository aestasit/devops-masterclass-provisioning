class setup::concourse {

  # docker::run { 'concourse-db':
  #   image            => "postgres:9.6",
  #   ports            => [
  #     '8443:443',
  #     '8480:80',
  #     '8422:22'
  #   ],
  #   env              => [
  #     "POSTGRES_DB=concourse",
  #     "POSTGRES_USER=concourse",
  #     "POSTGRES_PASSWORD=changeme",
  #     "PGDATA=/database",
  #   ],
  #   restart_service  => true,
  #   volumes          => [
  #     '/var/lib/gitlab/config:/etc/gitlab',
  #     '/var/lib/gitlab/logs:/var/log/gitlab',
  #     '/var/lib/gitlab/data:/var/opt/gitlab',
  #   ],
  #   extra_parameters => [
  #     '--restart=always',
  #     '--hostname gitlab.extremeaution.io'
  #   ],
  # }

  # concourse-db:
  # image: postgres:9.6
  # environment:
  # POSTGRES_DB: concourse
  # POSTGRES_USER: concourse
  # POSTGRES_PASSWORD: changeme
  # PGDATA: /database
  #
  # concourse-web:
  # image: concourse/concourse
  # links: [concourse-db]
  # command: web
  # depends_on: [concourse-db]
  # ports: ["8080:8080"]
  # volumes: ["./keys/web:/concourse-keys"]
  # restart: unless-stopped # required so that it retries until concourse-db comes up
  # environment:
  # CONCOURSE_BASIC_AUTH_USERNAME: concourse
  # CONCOURSE_BASIC_AUTH_PASSWORD: changeme
  # CONCOURSE_EXTERNAL_URL: "${CONCOURSE_EXTERNAL_URL}"
  # CONCOURSE_POSTGRES_HOST: concourse-db
  # CONCOURSE_POSTGRES_USER: concourse
  # CONCOURSE_POSTGRES_PASSWORD: changeme
  # CONCOURSE_POSTGRES_DATABASE: concourse
  #
  # concourse-worker:
  # image: concourse/concourse
  # privileged: true
  # links: [concourse-web]
  # depends_on: [concourse-web]
  # command: worker
  # volumes: ["./keys/worker:/concourse-keys"]
  # environment:
  # CONCOURSE_TSA_HOST: concourse-web


  # mkdir -p keys/web keys/worker
  #
  # ssh-keygen -t rsa -f ./keys/web/tsa_host_key -N ''
  # ssh-keygen -t rsa -f ./keys/web/session_signing_key -N ''
  #
  # ssh-keygen -t rsa -f ./keys/worker/worker_key -N ''
  #
  # cp ./keys/worker/worker_key.pub ./keys/web/authorized_worker_keys
  # cp ./keys/web/tsa_host_key.pub ./keys/worker
}

