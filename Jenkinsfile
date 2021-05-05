pipeline {
  agent any
  tools { 
        // Given names from Jenkins Global Tools
        maven 'maven3' 
        jdk 'jdk8' 
  }
  stages {
    stage('Build') {
      steps {
        echo 'Start building'
        git 'https://github.com/kaykim091090/spring-petclinic.git'
        // Testing before mvnw
        sh 'mvn -Dmaven.test.failure.ignore=true install'
      }
    }
    stage('Docker Build') {
      agent any
      steps {
        // Build with Dockerfile
        sh 'docker build -t petclinic-jar -f ./Dockerfile .'
      }
    }
  }
}
