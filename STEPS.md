
Setup steps:

- `gradlew terraformApply`
- `gradlew activateTerminationProtection`
- `gradlew setHostname`
- `gradlew updateApt`
- `gradlew updateHosts`
- `gradlew provisionPuppet` or `gradlew provisionAnsible`  
- `gradlew initializeKibana`
- `gradlew initializeRancher`
- `gradlew initializeGitlab`
- `gradlew updateJenkinsItems`
- `gradlew listIps`
- `gradlew listKeys`
- `gradlew listNetwork`

Tear-down steps:

- `gradlew disableTerminationProtection`
- `gradlew terraformDestroy`
