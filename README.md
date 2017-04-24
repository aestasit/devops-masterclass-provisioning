# devops-masterclass-provisioning

Provisioning scripts for DevOps Masterclass student and teacher infrastructure.

## Gradle tasks

Gradle scripts implement utility and glue code for invoking other tools.

### Properties

The following properties are available:

- downloadDir
- downloadThreads
- serverPort
- serverKey
- serverUser
- serverHostName

### Tasks

The following tasks are available:

- downloadTools
- terraformApply
- terraformDestroy
- provisionPuppet
- provisionAnsible

## Terraform

Terraform sets up 

- Network
- Keys
- Central server
- Student machines

## Provisioning

Provisioning of the central server has been implemented with Ansible and Puppet. Both tools produce equivalent setup featuring the following components:

- ELK
- Rancher
- Promotheus
- Grafana
- Swarm
