def ROS_IMAGE = 'docker.io/asoteloa/assignment:latest'
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
  - name: simulator
    image: ${ROS_IMAGE}
    command:
    - sleep
    args:
    - infinity
      """
    }
  }
  parameters { booleanParam(name: 'BUILD_ROS_IMAGE', defaultValue: false, description: 'Build ROS Image') }

  environment {
<<<<<<< HEAD
    ROS_IMAGE = 'docker.io/asoteloa/assignment:latest'
    DOCKER_CONFIG_PATH = '/kaniko/.docker/config.json'
=======
    DOCKER_CONFIG_PATH = '/kaniko/.docker/config.json'
    POD_NAME = "simulator-pod-${env.BUILD_ID}"
>>>>>>> 7bdc5b5 (Running 2 stages in the same container)
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
<<<<<<< HEAD
        sh '''#!/bin/sh
          echo Skiping build!
        '''
      }
    } // Run Simulator
=======
        container ('simulator') {
          sh "./simulator.sh"
        }
      }
    } // Run Simulator

    stage('Testing') {
      steps {
        container ('simulator') {
          sh "./run_test.sh"
        }
      }
    } // Testing

>>>>>>> 7bdc5b5 (Running 2 stages in the same container)
  } // stages
}