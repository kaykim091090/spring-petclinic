FROM openjdk:8
LABEL maintainer="kaykim091090@gmail.com"
EXPOSE 8888
ADD spring-petclinic-2.4.5.jar /home/spring-petclinic-2.4.5.jar
ENTRYPOINT ["java","-Dserver.port=8888","-jar","/home/spring-petclinic-2.4.5.jar"]
