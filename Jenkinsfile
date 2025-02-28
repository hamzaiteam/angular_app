pipeline {
    agent {
        docker {
            image 'node:16-alpine'
            args '-v /var/run/docker.sock:/var/run/docker.sock -u root' // Run as root to install packages
        }
    }

    triggers {
        githubPush()
    }
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials') 
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/hamzaiteam/angular_app.git', credentialsId: 'git-credentials'
            }
        }

        stage('Install Docker CLI') {
            steps {
                // Install Docker CLI in the Alpine-based container
                sh 'apk update && apk add docker'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }


        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                        docker build -t \${DOCKERHUB_CREDENTIALS_USR}/angular_app:\${BUILD_NUMBER} .
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh "docker login -u \${DOCKERHUB_CREDENTIALS_USR} -p \${DOCKERHUB_CREDENTIALS_PSW}"
                    sh "docker push \${DOCKERHUB_CREDENTIALS_USR}/angular_app:\${BUILD_NUMBER}"
                }
            }
        }
    }
}