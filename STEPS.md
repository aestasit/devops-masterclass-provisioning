
Setup steps:

- `gradlew terraformApply`
- `gradlew activateTerminationProtection`
- `gradlew setHostname`
- `gradlew updateApt`
- `gradlew provisionPuppet`
- `gradlew initializeKibanaConfiguration`
- `gradlew initializeRancher`
- `gradlew initializeGitlab`
- `gradlew updateHosts`
- `gradlew updateJenkinsItems`

Tear-down steps:

- `gradlew disableTerminationProtection`
- `gradlew terraformDestroy`
