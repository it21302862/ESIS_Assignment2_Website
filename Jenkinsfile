pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    echo '🏗️ Building Docker image...'
                    bat 'docker build -t esis-iso-assignment:latest .'
                }
            }
        }

        stage('Run Docker Container (Local Test)') {
            steps {
                script {
                    echo '🧪 Running container locally on port 9090...'
                    bat 'docker ps -a -q --filter "name=esis-container" | findstr . && docker rm -f esis-container || echo "No existing container to remove"'
                    bat 'docker run -d -p 9090:80 --name esis-container esis-iso-assignment:latest'
                }
            }
        }
    }
}
