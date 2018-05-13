
Setup steps:

- update student count in `gradle.propeties`
- update GitLab password in `gradle.propeties`

- `gradlew terraformApply`
- `gradlew activateTerminationProtection`
- `gradlew setHostname`
- `gradlew updateApt`
- `generateSSLCertificates`

- `gradlew provisionPuppet` or `gradlew provisionAnsible`

- wait 5 minutes for all services to fully initialize 
- manually access rancher UI from browser

- `gradlew initializeKibana`
- `gradlew initializeGitlab`

- `gradlew initializeRancher`

- manually create admin user in Jenkins

- `gradlew updateJenkinsItems`
- `gradlew listIps`
- `gradlew listKeys`
- `gradlew listNetwork`

Tear-down steps:

- `gradlew pullGitLabProjects`
- `gradlew disableTerminationProtection`
- `gradlew terminateAllServers`
- `gradlew deleteAllKeypairs`
- `gradlew terraformDestroy`
