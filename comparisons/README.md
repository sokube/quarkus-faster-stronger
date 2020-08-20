# Comparisons

The goal of this module is to show that quarkus is more efficient and more lightweight than spring-boot.

## Prepare docker images
If not yet done, you need to generate the docker images before playing with docker-compose and then k3d.
```
cd ../employee-sb && ./build-mvn-docker.sh
cd ../employee-quarkus && ./build-mvn-docker.sh
```

## Comparing with docker-compose

### Docker-compose
Simply run docker-compose from the docker-compose folder:
```
cd docker-compose && docker-compose up -d
```
There's two postgres containers defined: one for quarkus and the other is for spring-boot.
As quarkus-hibernate and hibernate does not use the same ddl-generators behind the hood, there's incompatibility when you use ```ddl.auto=update```

### Check availability

- Spring-boot: ```curl http://localhost:8092/hello```
- Quarkus with jvm: ```curl http://localhost:8081/hello```
- Quarkus native: ```curl http://localhost:8082/hello```

### Check startup time
- Spring-boot: ```docker logs docker-compose_employee-sb_1 | grep Started```
- Quarkus with jvm: ```docker logs docker-compose_employee-qk-jvm_1 | grep started```
- Quarkus native: ```docker logs docker-compose_employee-qk-native_1 | grep started```

==> Spring-boot ~10s, Quarkus-jvm ~3s, Quarkus-native ~0.1s

### Check resources used
Using ```docker stats```, you can see (when doing nothing):
<table>
<tr><th>resource</th><th>spring-boot</th><th>quarkus-jvm</th><th>quarkus-native</th></tr>
<tr><td>cpu</td><td>0.30~0.50</td><td>0.30~0.50</td><td>0.01~0.05</td></tr>
<tr><td>memory</td><td>~300Mb</td><td>~200Mb</td><td>~30Mb</td></tr>
</table>

### Generate data
Simple use endpoint /hello/generate for Docker container you want.

Don't forget this is not the same database used for spring-boot, but the database is shared between our two quarkus containers.

### Check how many containers you can run in parallel for each
Using swarm, you can play with replicas values in each of the stack, by using its dedicated docker-compose file and property "replicas":

```
docker stack deploy employee-sb --compose-file=docker-compose-only-sb/docker-compose.yaml
```
```
docker stack deploy employee-qk-jvm --compose-file=docker-compose-only-quarkus-jvm/docker-compose.yaml
```
```
docker stack deploy employee-qk-native --compose-file=docker-compose-only-quarkus-native/docker-compose.yaml
```

N.B: the following conclusion are with an intel i9 of 9th generation, and 8Gb RAM assigned to docker.

Playing with the number of replicas, will show you that:
- 30 replicas of spring-boot will begin to fail, and startup time is then very very long (20 seems to be the limit)
- 40 replicas with quarkus-jvm is still ok
- with quarkus native, you can go up to 100, startup time for containers is still < 1s
N.B.:
Don't forget that in docker-swarm you don't have "dependencies between containers".
So as quarkus is very fast for startup, you will see some failures because of the postgres container which is not fully started at the beginning of the deploy.

# In a Kubernetes environment: k3d

The goal of this part is to check if Quarkus really fits “perfectly” kubernetes, and have a look on how startup time can impact your service availability.

## What will we do?

Setup a kubernetes cluster with 5 deployments:
- One for the application in its spring-boot form
- One for the application in its quarkus with old-fashioned jvm form
- One for the application in its quarkus with GraalVM form
- Two postgres databases (one for quarkus, and the other for spring-boot)

There's only 3 replicas for each stack.
Then, we will setup 3 pods which check the availability of the service every second and kill 1 pod of each application form every

5 seconds between kills:
```
cd quarkus-k3d && ./create-kill-check.sh
```
15 seconds between kills:
```
cd quarkus-k3d && ./create-kill-check-slow.sh
```

Failures table (these numbers can changed, among your configuration):
<table>
<tr><th>kill every</th><th>spring-boot</th><th>quarkus-jvm</th><th>quarkus-native</th></tr>
<tr><td>5 seconds</td><td>58</td><td>13</td><td>0</td></tr>
<tr><td>15 seconds</td><td>37</td><td>13</td><td>0</td></tr>
</table>
