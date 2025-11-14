pipeline {
  agent none

  triggers {
    githubPush()
  }

  environment {
    AWS_REGION = "us-east-1"
    ECR_REPO   = "662930028566.dkr.ecr.us-east-1.amazonaws.com/ourrepo"
  }

  stages {

    // ----------- App build & push -----------
    stage('Build & Push Image with Kaniko') {
      when {
        changeset "nodeapp/**"
      }
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
    image: gcr.io/kaniko-project/executor:debug
    command: [ "cat" ]
    tty: true
    resources:
      requests:
        cpu: "1"
        memory: "2Gi"
      limits:
        cpu: "1.5"
        memory: "3Gi"
"""
        }
      }
      steps {
       container('kaniko') {
          sh '''
            echo "Building and pushing image to ECR..."
        
            # Extract last 3 characters of the Git commit
            SHORT_TAG=$(echo ${GIT_COMMIT} | tail -c 4)
        
            echo "Using tag: v.${SHORT_TAG}"
        
            /kaniko/executor \
              --context $WORKSPACE \
              --dockerfile $WORKSPACE/dockerfile \
              --destination $ECR_REPO:v.${SHORT_TAG} \
              --reproducible
          '''
        }

      }
    }

    // ----------- Terraform deploy -----------
    stage('Terraform Init & Apply') {
      when {
        changeset "terraform/**"
      }
      agent {
        kubernetes {
          yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    jenkins: terraform
spec:
  serviceAccountName: jenkins
  containers:
  - name: terraform
    image: hashicorp/terraform:1.9
    command: [ "cat" ]
    tty: true
    resources:
      requests:
        cpu: "0.5"
        memory: "512Mi"
      limits:
        cpu: "1"
        memory: "1Gi"
"""
        }
      }
      steps {
        container('terraform') {
          sh '''
            cd terraform
            terraform init -input=false
            terraform plan -no-color -input=false
          '''
        }
      }
    }
  }
}
