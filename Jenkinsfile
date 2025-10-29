pipeline {
    agent any

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    bat 'docker build -t esis-iso-assignment:latest .'
                }
            }
        }

        stage('Run Docker Container (Local Test)') {
            steps {
                script {
                    echo 'Running container locally on port 9090...'
                    
                    bat '''
                    docker ps -a --filter "name=esis-container" -q > temp.txt
                    set /p CID=<temp.txt
                    if defined CID (
                        docker rm -f esis-container
                    ) else (
                        echo No existing container to remove
                    )
                    del temp.txt
                    '''
                    
                    bat 'docker run -d -p 9090:80 --name esis-container esis-iso-assignment:latest'
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
        success {
            echo 'Docker container is running successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs above.'
        }
    }
}
