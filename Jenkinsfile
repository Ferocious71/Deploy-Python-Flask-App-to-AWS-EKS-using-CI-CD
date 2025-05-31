pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO = 'flask-app'
        EKS_CLUSTER = 'flask-eks-cluster'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://your-repo-url'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $(aws ecr describe-repositories --repository-names $ECR_REPO --region $AWS_REGION --query 'repositories[0].repositoryUri' --output text)"
                    sh "docker build -t $ECR_REPO:$IMAGE_TAG ."
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    def repoUri = sh(script: "aws ecr describe-repositories --repository-names $ECR_REPO --region $AWS_REGION --query 'repositories[0].repositoryUri' --output text", returnStdout: true).trim()
                    sh "docker tag $ECR_REPO:$IMAGE_TAG $repoUri:$IMAGE_TAG"
                    sh "docker push $repoUri:$IMAGE_TAG"
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    sh "aws eks update-kubeconfig --region $AWS_REGION --name $EKS_CLUSTER"
                    sh "kubectl set image deployment/flask-deployment flask-container=$repoUri:$IMAGE_TAG"
                }
            }
        }
    }
}
