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
                    // Safely remove existing container if it exists
                    bat 'docker ps -a -q --filter "name=esis-container" | findstr . && docker rm -f esis-container || echo "No existing container to remove"'
                    // Run new container
                    bat 'docker run -d -p 9090:80 --name esis-container esis-iso-assignment:latest'
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    echo '🚀 Deploying Docker container to EC2 (13.60.41.13)...'

                    // Path to your PEM key (use forward slashes)
                    String pemPath = "D:/GenkinsAccessGSIS.pem"
                    String ec2Host = "ec2-user@13.60.41.13"

                    // SSH directly to EC2 and deploy container
                    bat """
                    ssh -i "${pemPath}" -o StrictHostKeyChecking=no ${ec2Host} ^
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
