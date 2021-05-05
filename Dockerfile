FROM openjdk:8
LABEL maintainer="kaykim091090@gmail.com"
ADD spring-petclinic-2.4.5.jar /home/spring-petclinic-2.4.5.jar
ENTRYPOINT ["java","-jar","/home/spring-petclinic-2.4.5.jar"]
