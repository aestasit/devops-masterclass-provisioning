
Setup steps:

- update student count in `gradle.propeties`
- update GitLab password in `gradle.propeties`

- `gradlew terraformApply`
- `gradlew activateTerminationProtection`
- `gradlew setHostname`
- `gradlew updateApt`
- `gradlew generateSSLCertificates`

- `gradlew provisionPuppet` 

- wait 5 minutes for all services to fully initialize 

- TODO: first provisioning fails, need to login to Jenkins and update the list of the plugins and then run `gradlew provisionPuppet` again 

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
