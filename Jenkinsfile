pipeline {
  agent {
    kubernetes {
      yaml """
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: IfNotPresent
    command:
    - sleep
    args:
    - infinity
      """
    }
  }
  parameters { booleanParam(name: 'BUILD_ROS_IMAGE', defaultValue: false, description: 'Build ROS Image') }

  environment {
    ROS_IMAGE = 'docker.io/asoteloa/assignment:latest'
    DOCKER_CONFIG_PATH = '/kaniko/.docker/config.json'
  }

  stages {
    stage('Build ROS Image') {
      when { expression { params.BUILD_ROS_IMAGE } }
      steps {
        withCredentials([usernamePassword(credentialsId: 'docker-registry-abraham-credentials',
                                          usernameVariable: 'DOCKER_USER',
                                          passwordVariable: 'DOCKER_PASS')]) {
          container(name: 'kaniko', shell: '/busybox/sh') {
            sh """#!/busybox/sh
              mkdir -p /kaniko/.docker
              echo '{ "auths": { "https://index.docker.io/v1/": { "auth": "'\$(echo -n \$DOCKER_USER:\$DOCKER_PASS | base64)'" } } }' > \$DOCKER_CONFIG_PATH
              /kaniko/executor --context \$(pwd) --destination ${ROS_IMAGE}
            """
          }
        }
      }
    } // Build ROS Image

    stage ('Run Simulator') {
      steps {
        sh '''#!/bin/sh
          echo Skiping build!
        '''
      }
    } // Run Simulator
  } // stages
}