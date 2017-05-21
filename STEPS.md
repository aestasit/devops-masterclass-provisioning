
Setup steps:

- update student count in gradle.propeties and 00_variables.tf
- `gradlew terraformApply`
- `gradlew activateTerminationProtection`
- `gradlew setHostname`
- `gradlew updateApt`
- `gradlew updateHosts`
- `gradlew provisionPuppet` or `gradlew provisionAnsible`  
- wait 5 minutes for all services to fully initialize 
- add all hosts to local hosts file
- manually access rancher UI from browser
- `gradlew initializeRancher`
- `gradlew initializeKibana`
- `gradlew initializeGitlab`
- `gradlew updateJenkinsItems`
- `gradlew listIps`
- `gradlew listKeys`
- `gradlew listNetwork`

Tear-down steps:

- `gradlew disableTerminationProtection`
- `gradlew terraformDestroy`
