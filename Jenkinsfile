pipeline {
    agent any

    stages {
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
                    echo 'Running container on port 9090...'
                    bat 'docker rm -f esis-container || exit 0'
                    bat 'docker run -d -p 9090:80 --name esis-container esis-iso-assignment:latest'
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    echo 'Deploying Docker container to EC2...'
                }
                sshagent(['ec2-ssh-key']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ec2-user@13.60.41.13 << 'EOF'
                        echo "===== Connected to EC2 Instance ====="
                        
                        # Stop and remove any old container
                        docker rm -f esis-container || true
                        
                        # Pull latest Docker image from Jenkins build (if pushed)
                        # docker pull your-dockerhub-username/esis-iso-assignment:latest
                        
                        # Or build directly from your repo if source is cloned
                        cd /home/ec2-user/app || mkdir -p /home/ec2-user/app
                        cd /home/ec2-user/app
                        
                        # (Optional) If using Git repo on EC2:
                        # git pull origin main
                        
                        echo "===== Running new container ====="
                        docker run -d -p 9090:80 --name esis-container esis-iso-assignment:latest
                        EOF
                    '''
                }
            }
        }
    }
}
