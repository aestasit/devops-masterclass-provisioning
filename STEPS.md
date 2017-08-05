
Setup steps:

- update student count in `gradle.propeties` and `00_variables.tf`
- update GitLab password in `gradle.propeties` and `gitlab.pp`

- `gradlew terraformApply`
- `gradlew activateTerminationProtection`
- `gradlew setHostname`
- `gradlew updateApt`

- `gradlew provisionPuppet` or `gradlew provisionAnsible`  

- wait 5 minutes for all services to fully initialize 
- manually access rancher UI from browser

- `gradlew initializeRancher`
- `gradlew initializeKibana`
- `gradlew initializeGitlab`
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
