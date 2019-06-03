
Setup steps:

+ update student count in `gradle.propeties`
+ update GitLab password in `gradle.propeties`

+ `gradlew terraformApply`
+ `gradlew activateTerminationProtection`
+ `gradlew setHostname`
+ `gradlew updateApt`
+ `gradlew generateSSLCertificates`

+ `gradlew provisionPuppet` 

- wait 5 minutes for all services to fully initialize 

- TODO: first provisioning semi-fails for Jenkins, run `gradlew provisionPuppet` again 
- TODO: jenkins shows a set of warnings

- TODO: go to GitLab, set new password for root, create api token for root with all permissions and change gradle.properties to contain that token
- `gradlew initializeGitlab`

- `gradlew updateJenkinsItems`

- `gradlew listIps`
- `gradlew listKeys`
- `gradlew listNetwork`

- TODO: `gradlew initializeKibana`



Tear-down steps:

- `gradlew pullGitLabProjects`
- `gradlew disableTerminationProtection`
- `gradlew terminateAllServers`
- `gradlew deleteAllKeypairs`
- `gradlew terraformDestroy`
