FROM frolvlad/alpine-oraclejdk8
VOLUME /tmp
ADD  build/libs/EurekaServer-0.0.1-SNAPSHOT.jar eurekaserver.jar
EXPOSE 8761
ENTRYPOINT ["java","-jar","/eurekaserver.jar"]