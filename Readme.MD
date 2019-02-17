# Run Jenkins Master

#### Create docker base images
`docker build -t <registry-name>/<repository>:tag-name
`
``` 
docker build -t ascendcorp/oneplanet-jenkins-base:1.0 ./master
```

``` 
docker run -d -p 49001:8080 \
-p 50001:50001 \
-v `pwd`/jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
--name jenkins-master ascendcorp/oneplanet-jenkins-master-base:1.8
```