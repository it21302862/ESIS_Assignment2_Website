pipeline {
    agent any

    environment {
        IMAGE_NAME = "esis-iso-assignment"
        CONTAINER_NAME = "esis-container"
        LOCAL_PORT = "9090"
        EC2_USER = "ec2-user"
        EC2_HOST = "13.60.41.13"   // 🔹 your EC2 public IP
        CREDENTIAL_ID = "ee2cd2f4-0c7e-45f7-87af-27d71144dc73" // 🔹 your Jenkins SSH credential ID
    }

    stages {
        stage('Clean Local Container') {
            steps {
                script {
                    echo '🧹 Cleaning up old local container...'
                    bat """
                    docker ps -a -q --filter "name=%CONTAINER_NAME%" | findstr . && docker rm -f %CONTAINER_NAME% || echo "No existing container to remove"
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo '🏗️ Building new Docker image...'
                    bat "docker build --no-cache -t %IMAGE_NAME%:latest ."
                }
            }
        }

        stage('Run Docker Container Locally') {
            steps {
                script {
                    echo "🧪 Running container locally on port %LOCAL_PORT%..."
                    bat "docker run -d -p %LOCAL_PORT%:80 --name %CONTAINER_NAME% %IMAGE_NAME%:latest"
                }
            }
        }

        stage('Verify Local Deployment') {
            steps {
                script {
                    echo '🔍 Checking if the local container is running...'
                    bat "docker ps | findstr %CONTAINER_NAME%"
                    echo "🌐 Visit http://localhost:%LOCAL_PORT% for local test"
                    echo "🌐 Visit http://%EC2_HOST%:9090 for EC2 deployment"
                }
            }
        }
    }

    post {
        failure {
            echo "❌ Pipeline failed! Check Jenkins logs for details."
        }
        success {
            echo "✅ Pipeline completed successfully!"
        }
    }
}
