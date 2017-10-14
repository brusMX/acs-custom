FROM frolvlad/alpine-oraclejdk8
VOLUME /tmp
ADD  target/azure-servicebus-samples-topicclientquickstart-1.0.0-jar-with-dependencies.jar servicebustopiclistener.jar 
EXPOSE 8095
ENTRYPOINT ["java","-jar","/servicebustopiclistener.jar"]