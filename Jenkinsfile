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

        stage('Deploy to EC2') {
            steps {
                script {
                    echo '🚀 Deploying Docker container to EC2...'

                    // Use Jenkins SSH agent
                    sshagent(['ee2cd2f4-0c7e-45f7-87af-27d71144dc73']) { // Use your credential ID
                        bat """
                        ssh -o StrictHostKeyChecking=no ec2-user@13.60.41.13 ^
                        "sudo systemctl start docker || true && \
                        docker rm -f esis-container || true && \
                        mkdir -p /home/ec2-user/app && \
                        cd /home/ec2-user/app && \
                        echo '===== 🐳 Running new container on port 9090 =====' && \
                        docker run -d -p 9090:80 --name esis-container esis-iso-assignment:latest"
                        """
                    }
                }
            }
        }
    }
}
