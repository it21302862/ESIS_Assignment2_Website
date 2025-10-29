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
                    bat 'docker rm -f esis-container || exit 0'
                    bat 'docker run -d -p 9090:80 --name esis-container esis-iso-assignment:latest'
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    echo '🚀 Deploying Docker container to EC2 (13.60.41.13)...'
                }

                sshagent(['ec2-ssh-key']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ec2-user@13.60.41.13 << 'EOF'
                        echo "===== ✅ Connected to EC2 Instance ====="

                        # Ensure Docker is running
                        sudo systemctl start docker || true

                        # Stop and remove any old container
                        docker rm -f esis-container || true

                        # Ensure app directory exists
                        mkdir -p /home/ec2-user/app
                        cd /home/ec2-user/app

                        # (Optional) If using Git repo on EC2:
                        # git pull origin main

                        echo "===== 🐳 Running new container on port 9090 ====="
                        docker run -d -p 9090:80 --name esis-container esis-iso-assignment:latest
                        EOF
                    '''
                }
            }
        }
    }
}
