pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/it21302862/ESIS_Assignment2_Website.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t my-iso-site:latest .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'docker login -u $USER -p $PASS'
                    sh 'docker tag my-iso-site:latest yourdockerhubusername/my-iso-site:latest'
                    sh 'docker push yourdockerhubusername/my-iso-site:latest'
                }
            }
        }

        stage('Deploy with Ansible') {
            steps {
                sh 'ansible-playbook deploy.yml'
            }
        }
    }
}
