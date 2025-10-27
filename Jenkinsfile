pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    sh 'docker build -t esis-iso-assignment:latest .'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    echo 'Running container on port 9090...'
                    sh 'docker rm -f esis-container || true'
                    sh 'docker run -d -p 9090:80 --name esis-container esis-iso-assignment:latest'
                }
            }
        }
    }
}
