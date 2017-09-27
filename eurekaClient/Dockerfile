FROM frolvlad/alpine-oraclejdk8
VOLUME /tmp
ADD  build/libs/eurekaClient-0.0.1-SNAPSHOT.jar eurekaclient.jar
EXPOSE 8090
ENTRYPOINT ["java","-jar","/eurekaclient.jar"]