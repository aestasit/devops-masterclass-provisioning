
Setup steps:

- `gradlew terraformApply`
- `gradlew activateTerminationProtection`
- `gradlew setHostname`
- `gradlew provisionPuppet`
- `gradlew initializeKibanaConfiguration`

Tear-down steps:

- `gradlew disableTerminationProtection`
- `gradlew terraformDestroy`
