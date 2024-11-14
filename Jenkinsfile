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
    imagePullPolicy: IfNotPresent
    command:
    - sleep
    args:
    - infinity
      """
    }
  }
  parameters {
    booleanParam(name: 'BUILD_ROS_IMAGE', defaultValue: false, description: 'Build ROS Image')
    booleanParam(name: 'RUN_FAIL_TEST', defaultValue: false, description: 'Run failing test')
  }

  environment {
    DOCKER_CONFIG_PATH = '/kaniko/.docker/config.json'
    BUILD_STATUS = 'FAILURE'
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
        container ('simulator') {
          sh """
            ./simulator.sh &
            sleep 20
          """       // Sleeps for 20 seconds to allow the simulator to start
        }
      }
    } // Run Simulator

    stage('Testing') {
      steps {
        container ('simulator') {
          sh """
            if [ "$params.RUN_FAIL_TEST" = true ]; then
              FAIL=--fail
            fi
            ./run_test.sh \$FAIL
          """
        }
      }
    } // Testing
  } // stages

    post {
      always {
        script {BUILD_STATUS = currentBuild.currentResult}
        mail (
          to: "asoteloa@outlook.com",
          from: "Jenkins <no-reply@mail.com>",
          subject: "Jenkins pipeline ${BUILD_STATUS}: ${env.JOB_NAME} - Build #${env.BUILD_NUMBER}",
          body: "The pipeline \"${env.JOB_NAME}\" has completed with status: ${BUILD_STATUS}.\nBuild URL: ${env.BUILD_URL}"
        )
      }
    } // post
  
}