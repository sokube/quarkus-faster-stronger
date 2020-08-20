./mvnw clean install
docker build . -f src/main/docker/Dockerfile -t employee-sb:0.0.1-SNAPSHOT
