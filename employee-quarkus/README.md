# Employee spring-boot project

### Project features
This simple quarkus project defines entities persons which can be employees or candidates.

Each person has a list of skills with levels.

### Technical considerations
Database used is a simple postgres database and is auto-updated at start of the application.

### Generate the docker images employee-quarkus-jvm & employee-quarkus-native:
export GRAALVM_HOME=/Library/Java/JavaVirtualMachines/graalvm-ce-lts-java11-19.3.2/Contents/Home

export JAVA_HOME=GRAALVM_HOME

export PATH=/Library/Java/JavaVirtualMachines/graalvm-ce-lts-java11-19.3.2/Contents/Home/bin:"$PATH"

Using the ```build-mvn-docker.sh``` you will generate two docker images:
- one with classical JVM
- one with GraalVM

### Endpoints:
- HTTPGet: <server_url:serverport>/hello can be used to check if server is up and running (simple return of string "hello")
- HTTPPost: <server_url:serverport>/hello/create can be used to create a person
- HTTPGet: <server_url:serverport>/hello/listEmployee list the employees
- HTTPGet: <server_url:serverport>/hello/listPersons list the persons
- HTTPGet: <server_url:serverport>/hello/generate generates 100 persons

