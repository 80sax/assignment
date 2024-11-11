pipeline {
  agent {
    kubernetes {
      label 'jenkins-assigment-jenkins-agent'
      defaultContainer 'jnlp'
    }
  }
  stages {
    stage('ROS setup') {
      steps {
        echo 'Building..'
      }
    }
    stage('Launch Simulator') {
      steps {
        echo 'Testing..'
      }
    }
    stage('Test') {
      steps {
        echo 'Deploying....'
      }
    }
  }
}