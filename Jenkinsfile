pipeline {
  agent none

  triggers {
    githubPush()   // automatically run when a push happens
  }

  environment {
    AWS_REGION = "us-east-1"
    ECR_REPO   = "865773021449.dkr.ecr.us-east-1.amazonaws.com/ourrepo"
  }

  stages {
    stage('Build & Push Image with Kaniko') {
      agent {
        kubernetes {
          yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    jenkins: kaniko
spec:
  serviceAccountName: jenkins
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:latest
    command:
    - cat
    tty: true
"""
        }
      }
      steps {
        container('kaniko') {
          sh '''
            echo "Building and pushing image to ECR..."
            /kaniko/executor \
              --context $WORKSPACE \
              --dockerfile $WORKSPACE/Dockerfile \
              --destination $ECR_REPO:latest \
              --destination $ECR_REPO:${GIT_COMMIT::7} \
              --reproducible
          '''
        }
      }
    }
  }
}
