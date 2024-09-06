pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages{
        stage('build project'){
            steps{
                git 'https://github.com/suguslove10/finance-me-microservice.git'
                sh 'mvn clean package'
              
            }
        }
        stage('Building  docker image'){
            steps{
                script{
                    sh 'docker build -t suguslove10/finance-me-microservice:v1 .'
                    sh 'docker images'
                }
            }
        }
        stage('push to docker-hub'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'Docker-cred', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh "echo $PASS | docker login -u $USER --password-stdin"
                    sh 'docker push suguslove10/finance-me-microservice:v1'
                }
            }
        }
        
        stage('Terraform Operations for test workspace') {
            steps {
                sh '''
                terraform workspace select test || terraform workspace new test
                terraform init
                terraform plan
                terraform destroy -auto-approve
                '''
            }
        }
       stage('Terraform destroy & apply for test workspace') {
            steps {
                sh 'terraform apply -auto-approve'
            }
       }
       stage('Terraform Operations for Production workspace') {
            when {
                expression { return currentBuild.currentResult == 'SUCCESS' }
            }
            steps {
                sh '''
                terraform workspace select prod || terraform workspace new prod
                terraform init
                if terraform state show aws_key_pair.example 2>/dev/null; then
                    echo "Key pair already exists in the prod workspace"
                else
                    terraform import aws_key_pair.example key02 || echo "Key pair already imported"
                fi
                terraform destroy -auto-approve
                terraform apply -auto-approve
                '''
            }
       }
    }
}
