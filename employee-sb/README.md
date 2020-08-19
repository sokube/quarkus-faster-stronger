# Employee spring-boot project

### Project features
This simple spring-boot project defines entities persons which can be employees or candidates.

Each person has a list of skills with levels.

### Technical considerations
Database used is a simple postgres database and is auto-updated at start of the application.

Using the ```build-maven-docker.sh``` you will generate the docker image.

The generated docker image exposes the server port 8080.

### Endpoints:
- HTTPGet: <server_url:serverport>/hello can be used to check if server is up and running (simple return of string "hello")
- HTTPPost: <server_url:serverport>/hello/create can be used to create a person
- HTTPGet: <server_url:serverport>/hello/listEmployee list the employees
- HTTPGet: <server_url:serverport>/hello/listPersons list the persons
- HTTPGet: <server_url:serverport>/hello/generate generates 100 persons

