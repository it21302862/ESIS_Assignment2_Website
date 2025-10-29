pipeline {
    agent any

    environment {
        // Change this to your Docker Hub username
        DOCKER_HUB_REPO = 'it21302862/esis-iso-assignment'
        IMAGE_TAG = 'latest'
        EC2_HOST = '13.60.41.13'
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    bat "docker build -t ${DOCKER_HUB_REPO}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Run Docker Container (Local Test)') {
            steps {
                script {
                    echo 'Running container locally on port 9090...'
                    bat '''
                        for /f %%i in ('docker ps -a -q --filter "name=^/esis-container$"') do docker rm -f %%i
                        echo "Old container removed (if existed)"
                    '''
                    bat "docker run -d -p 9090:80 --name esis-container ${DOCKER_HUB_REPO}:${IMAGE_TAG}"
                    echo 'Local container running at http://localhost:9090'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    echo 'Pushing image to Docker Hub...'
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        bat "echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin"
                        bat "docker push ${DOCKER_HUB_REPO}:${IMAGE_TAG}"
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    echo 'Deploying to EC2 instance...'
                    withCredentials([sshUserPrivateKey(
                        credentialsId: 'ec2-ssh-key',
                        keyFileVariable: 'SSH_KEY',
                        usernameVariable: 'SSH_USER'
                    )]) {
                        bat """
                            ssh -i "${SSH_KEY}" -o StrictHostKeyChecking=no ${SSH_USER}@${EC2_HOST} \"
                            sudo systemctl start docker && 
                            docker rm -f esis-container || true && 
                            docker pull ${DOCKER_HUB_REPO}:${IMAGE_TAG} && 
                            docker run -d -p 9090:80 --name esis-container ${DOCKER_HUB_REPO}:${IMAGE_TAG} && 
                            echo 'Deployed successfully! Access at http://${EC2_HOST}:9090'
                            \"
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up local test container
            bat 'docker rm -f esis-container || exit 0'
            bat 'docker rmi $(docker images -q --filter "dangling=true") || exit 0'
            echo 'Pipeline cleanup complete.'
        }
        success {
            echo 'Deployment successful!'
        }
        failure {
            {
            echo 'Pipeline failed.'
        }
    }
}