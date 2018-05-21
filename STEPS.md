
Setup steps:

- update student count in `gradle.propeties`
- update GitLab password in `gradle.propeties`

- `gradlew terraformApply`
- `gradlew activateTerminationProtection`
- `gradlew setHostname`
- `gradlew updateApt`
- `generateSSLCertificates`

- `gradlew provisionPuppet` 

- wait 5 minutes for all services to fully initialize 

- go to GitLab, set new password for root, create api token for root with all permissions and change gradle.properties to contain that token
- `gradlew initializeGitlab`

- TODO: manually create admin user in Jenkins

- `gradlew updateJenkinsItems`

- `gradlew listIps`
- `gradlew listKeys`
- `gradlew listNetwork`

- TODO: `gradlew initializeKibana`

- TODO: manually access rancher UI from browser
- TODO: `gradlew initializeRancher`


Tear-down steps:

- `gradlew pullGitLabProjects`
- `gradlew disableTerminationProtection`
- `gradlew terminateAllServers`
- `gradlew deleteAllKeypairs`
- `gradlew terraformDestroy`
