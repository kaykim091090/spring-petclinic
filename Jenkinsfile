pipeline {
  agent any
  tools { 
        maven 'maven3' 
        jdk 'jdk8' 
  }
  stages {
    stage('Maven Build') {
      steps {
        echo 'Start building'
        // Already provided via Jenkins SCM
        // git 'https://github.com/kaykim091090/spring-petclinic.git'
        // Testing before mvnw
        // sh 'mvn -Dmaven.test.failure.ignore=true install'
        sh './mvnw package'
      }
      post {
        success {
          echo 'SUCCESS :: Next - Docker Build'
        }
        failure {
          echo 'FAILURE :: No Docker building. Stopping'
        }
      }
    }
    stage('Docker Build') {
      agent any
      steps {
        // Since ./ will be the internal docker instance, moving the target JAR to ./
        sh 'cp /var/jenkins_home/workspace/kkim-petclinic-pipe/target/spring-petclinic-2.4.5.jar ./'
        // Build with Dockerfile
        sh 'docker build -t petclinic-jar -f ./Dockerfile .'
      }
      post {
        success {
          echo 'SUCCESS :: PetClinic JAR exported as Docker Image'
        }
        failure {
          echo 'FAILURE :: No Docker Image for you! Check ASAP'
        }
      }
    }
  }
}
