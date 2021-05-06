# Forked Spring PetClinic Jenkins Pipe Assignment [![Build Status](https://travis-ci.org/spring-projects/spring-petclinic.png?branch=main)](https://travis-ci.org/spring-projects/spring-petclinic/)

## Prerequisites on Windows 10 Home Edition
* Install Docker Desktop (https://www.docker.com/products/docker-desktop)
* Install Java (Version 8 in my case)
* Install Maven (Version 3.8.1 in my case)
* Install Git (https://git-scm.com/download/win)
* Install Cygwin (https://cygwin.com/install.html)

## Steps
1) Pull Jenkins image (I used verion lts) from DockerHub to local (at Cygwin)
    ```
    docker image pull jenkins/jenkins:lts 
    ```

2) Create a Docker volume to persist Jenkins data
    ```
    docker volume create jfrog-kkim-volume2
    ```
3) Create a Docker container with the image and volume above. I created another container (50000:50000) within the container to ensure Jenkins can build maven from its executing container. 
    ```
    docker run -v /var/run/docker.sock:/var/run/docker.sock -v jfrog-kkim-volume2:/var/jenkins_home \ 
    -p 8100:8080 -p 50000:50000 --name jfrog-kkim-container3 jenkins/jenkins:lts
    ```
4) To make sure the Jenkins container can talk to Docker socket to inner mvn-build, I installed "docker.io" as well as elevated the user "jenkins" to "docker" user group. Also, modified a permission of the socket file for "jenkins".
    ```
    docker exec -it -u 0 jfrog-kkim-container2 bash # Getting Root-access bash
    apt-get update && apt-get install -y docker.io 
    groupadd docker
    usermod -aG docker jenkins
    chmod 666 /var/run/docker.sock
    ```
5) Restart the container
6) Install Jenkins plugins for Maven and Docker
7) Setup a Jenkins Pipeline with the GitHub forced source "https://github.com/kaykim091090/spring-petclinic"
8) Build (with Jenkinsfile at the GitHub)
9) Upon success, #8 produces a local docker image file of the Spring PetClinic JAR
10) Create a local container with the image to test
    ```
    docker run -v /var/run/docker.sock:/var/run/docker.sock -v jfrog-kkim-volume3:/var/jenkins_home \
    -p 8888:8888 --name jfrog-kkim-petclinic kaykim091090/petclinic-jar:latest
    ```
11) TA-DA. Your PetClinic is on your browser (http://localhost:8888/) now! 

12) [Extra] To enable Jenkins Pipe - Jfrog Artifactory Integration
I created this scenario as a different Docker image & container to separate out from above. 
    ```
    https://www.jfrog.com/confluence/display/JFROG/Configuring+Jenkins+Artifactory+Plug-in
    https://www.jfrog.com/confluence/display/JFROG/Jenkins+Artifactory+Plug-in
    https://github.com/jfrog/project-examples/blob/master/jenkins-examples
                                /pipeline-examples/scripted-examples/maven-example/Jenkinsfile
    ```
    "Jenkinsfile" for this scenario was added to:
    ```
    https://github.com/kaykim091090/spring-petclinic/blob/master/JFrog_Jenkinsfile
    ```

## Issues Encountered (& Resolved)
1) Windows is not the best environment to run Jenkins as-it-is, so I ran it on the localhost/Docker.
Since Jenkins is already running on the container, it had various problems, such as not finding maven installed in one container or not able to build since it could not find another container to execute. After resarching, I followed the solution found on the DockerHub Community Forum. 
2) Since the port 8080 was already occupied, I could not see the expecting homepage when I ran PetClinic JAR or Docker Image. That was resolved by changing the embedded tomcat port parameter in Dockerfile when we run the JAR. 

## Deliverables
1) GitHub repo: https://github.com/kaykim091090/spring-petclinic
    - https://github.com/kaykim091090/spring-petclinic/blob/master/Jenkinsfile
     - https://github.com/kaykim091090/spring-petclinic/blob/master/Dockerfile

2) DockerHub repo: https://hub.docker.com/r/kaykim091090/petclinic-jar
#
#
#
---
# Spring PetClinic Sample Application [![Build Status](https://travis-ci.org/spring-projects/spring-petclinic.png?branch=main)](https://travis-ci.org/spring-projects/spring-petclinic/)

## Understanding the Spring Petclinic application with a few diagrams
<a href="https://speakerdeck.com/michaelisvy/spring-petclinic-sample-application">See the presentation here</a>

## Running petclinic locally
Petclinic is a [Spring Boot](https://spring.io/guides/gs/spring-boot) application built using [Maven](https://spring.io/guides/gs/maven/). You can build a jar file and run it from the command line:


```
git clone https://github.com/spring-projects/spring-petclinic.git
cd spring-petclinic
./mvnw package
java -jar target/*.jar
```

You can then access petclinic here: http://localhost:8080/

<img width="1042" alt="petclinic-screenshot" src="https://cloud.githubusercontent.com/assets/838318/19727082/2aee6d6c-9b8e-11e6-81fe-e889a5ddfded.png">

Or you can run it from Maven directly using the Spring Boot Maven plugin. If you do this it will pick up changes that you make in the project immediately (changes to Java source files require a compile as well - most people use an IDE for this):

```
./mvnw spring-boot:run
```

## In case you find a bug/suggested improvement for Spring Petclinic
Our issue tracker is available here: https://github.com/spring-projects/spring-petclinic/issues


## Database configuration

In its default configuration, Petclinic uses an in-memory database (H2) which
gets populated at startup with data. The h2 console is automatically exposed at `http://localhost:8080/h2-console`
and it is possible to inspect the content of the database using the `jdbc:h2:mem:testdb` url.
 
A similar setup is provided for MySql in case a persistent database configuration is needed. Note that whenever the database type is changed, the app needs to be run with a different profile: `spring.profiles.active=mysql` for MySql.

You could start MySql locally with whatever installer works for your OS, or with docker:

```
docker run -e MYSQL_USER=petclinic -e MYSQL_PASSWORD=petclinic -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=petclinic -p 3306:3306 mysql:5.7.8
```

Further documentation is provided [here](https://github.com/spring-projects/spring-petclinic/blob/main/src/main/resources/db/mysql/petclinic_db_setup_mysql.txt).

## Working with Petclinic in your IDE

### Prerequisites
The following items should be installed in your system:
* Java 8 or newer.
* git command line tool (https://help.github.com/articles/set-up-git)
* Your preferred IDE 
  * Eclipse with the m2e plugin. Note: when m2e is available, there is an m2 icon in `Help -> About` dialog. If m2e is
  not there, just follow the install process here: https://www.eclipse.org/m2e/
  * [Spring Tools Suite](https://spring.io/tools) (STS)
  * IntelliJ IDEA
  * [VS Code](https://code.visualstudio.com)

### Steps:

1) On the command line
    ```
    git clone https://github.com/spring-projects/spring-petclinic.git
    ```
2) Inside Eclipse or STS
    ```
    File -> Import -> Maven -> Existing Maven project
    ```

    Then either build on the command line `./mvnw generate-resources` or using the Eclipse launcher (right click on project and `Run As -> Maven install`) to generate the css. Run the application main method by right clicking on it and choosing `Run As -> Java Application`.

3) Inside IntelliJ IDEA
    In the main menu, choose `File -> Open` and select the Petclinic [pom.xml](pom.xml). Click on the `Open` button.

    CSS files are generated from the Maven build. You can either build them on the command line `./mvnw generate-resources` or right click on the `spring-petclinic` project then `Maven -> Generates sources and Update Folders`.

    A run configuration named `PetClinicApplication` should have been created for you if you're using a recent Ultimate version. Otherwise, run the application by right clicking on the `PetClinicApplication` main class and choosing `Run 'PetClinicApplication'`.

4) Navigate to Petclinic

    Visit [http://localhost:8080](http://localhost:8080) in your browser.


## Looking for something in particular?

|Spring Boot Configuration | Class or Java property files  |
|--------------------------|---|
|The Main Class | [PetClinicApplication](https://github.com/spring-projects/spring-petclinic/blob/main/src/main/java/org/springframework/samples/petclinic/PetClinicApplication.java) |
|Properties Files | [application.properties](https://github.com/spring-projects/spring-petclinic/blob/main/src/main/resources) |
|Caching | [CacheConfiguration](https://github.com/spring-projects/spring-petclinic/blob/main/src/main/java/org/springframework/samples/petclinic/system/CacheConfiguration.java) |

## Interesting Spring Petclinic branches and forks

The Spring Petclinic "main" branch in the [spring-projects](https://github.com/spring-projects/spring-petclinic)
GitHub org is the "canonical" implementation, currently based on Spring Boot and Thymeleaf. There are
[quite a few forks](https://spring-petclinic.github.io/docs/forks.html) in a special GitHub org
[spring-petclinic](https://github.com/spring-petclinic). If you have a special interest in a different technology stack
that could be used to implement the Pet Clinic then please join the community there.


## Interaction with other open source projects

One of the best parts about working on the Spring Petclinic application is that we have the opportunity to work in direct contact with many Open Source projects. We found some bugs/suggested improvements on various topics such as Spring, Spring Data, Bean Validation and even Eclipse! In many cases, they've been fixed/implemented in just a few days.
Here is a list of them:

| Name | Issue |
|------|-------|
| Spring JDBC: simplify usage of NamedParameterJdbcTemplate | [SPR-10256](https://jira.springsource.org/browse/SPR-10256) and [SPR-10257](https://jira.springsource.org/browse/SPR-10257) |
| Bean Validation / Hibernate Validator: simplify Maven dependencies and backward compatibility |[HV-790](https://hibernate.atlassian.net/browse/HV-790) and [HV-792](https://hibernate.atlassian.net/browse/HV-792) |
| Spring Data: provide more flexibility when working with JPQL queries | [DATAJPA-292](https://jira.springsource.org/browse/DATAJPA-292) |


# Contributing

The [issue tracker](https://github.com/spring-projects/spring-petclinic/issues) is the preferred channel for bug reports, features requests and submitting pull requests.

For pull requests, editor preferences are available in the [editor config](.editorconfig) for easy use in common text editors. Read more and download plugins at <https://editorconfig.org>. If you have not previously done so, please fill out and submit the [Contributor License Agreement](https://cla.pivotal.io/sign/spring).

# License

The Spring PetClinic sample application is released under version 2.0 of the [Apache License](https://www.apache.org/licenses/LICENSE-2.0).

[spring-petclinic]: https://github.com/spring-projects/spring-petclinic
[spring-framework-petclinic]: https://github.com/spring-petclinic/spring-framework-petclinic
[spring-petclinic-angularjs]: https://github.com/spring-petclinic/spring-petclinic-angularjs 
[javaconfig branch]: https://github.com/spring-petclinic/spring-framework-petclinic/tree/javaconfig
[spring-petclinic-angular]: https://github.com/spring-petclinic/spring-petclinic-angular
[spring-petclinic-microservices]: https://github.com/spring-petclinic/spring-petclinic-microservices
[spring-petclinic-reactjs]: https://github.com/spring-petclinic/spring-petclinic-reactjs
[spring-petclinic-graphql]: https://github.com/spring-petclinic/spring-petclinic-graphql
[spring-petclinic-kotlin]: https://github.com/spring-petclinic/spring-petclinic-kotlin
[spring-petclinic-rest]: https://github.com/spring-petclinic/spring-petclinic-rest
