pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Use the Git plugin to checkout the code
                git branch: 'master', url: 'https://github.com/ambika-angadi/jenkins-react-app.git'
            }
        }

        stage('Build') {
            steps {
                script {
                    sh 'docker ps --filter name=node | grep node && docker kill node || true'
                    sh 'docker run -d --rm --name node -v ${WORKSPACE}:/var/app -w /var/app node:lts-bullseye tail -f /dev/null'
                    sh 'docker exec node npm --version'
                    sh 'docker exec node ls -la'
                    sh 'docker exec node npm ci'
                    sh 'echo "FROM nginx:latest" > Dockerfile'
                    sh 'echo "COPY . /usr/share/nginx/html" >> Dockerfile'
                    sh 'docker build -t my-nginx-image .'
                    sh 'docker kill node'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def imageName = 'my-nginx-image'
                    def repoName = 'ambika-angadi/jenkins-react-app' // Update with your repository name
                    def imageTag = "${repoName}:${BUILD_ID}" // Use BUILD_ID as the tag

                    sh "docker build -t ${imageTag} ."
                    sh "docker tag ${imageTag} ${imageName}"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Copy the Docker image to the EC2 instance
                    sh "/usr/bin/scp -i /home/ambika/.ssh/awskey dockeruserambi/ambika-angadi/jenkins-react-app:${env.BUILD_NUMBER} ubuntu@3.75.210.46:/home/ubuntu"

                    // SSH into the EC2 instance and run the container
                    sshagent(['awskey']) {
                        sh """
                            ssh -i /home/ambika/.ssh/awskey ubuntu@3.75.210.46 << 'EOF'
                            docker stop my-nginx-container || true
                            docker rm my-nginx-container || true
                            docker run -d --name my-nginx-container -p 80:80 dockeruserambi/ambika-angadi/jenkins-react-app:${env.BUILD_NUMBER}
                            EOF
                        """
                    }
                }
            }
        }

        stage('Cleanup') {
            steps {
                deleteDir()
            }
        }
    }

    post {
        success {
            cleanWs()
        }
    }
}
