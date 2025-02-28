pipeline {
stage('Prepare Docker CLI') {
    steps {
        sh 'apk add --no-cache docker-cli'
    }
}
    agent {
        docker {
            image 'node:16-alpine'
            // Mount the Docker socket if you need to run Docker commands (like building images) later
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        // Reference the Jenkins credentials with ID 'dockerhub-credentials'
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials') 
    }

    stages {
        stage('Checkout') {
            steps {
                // Updated repository URL with your GitHub repo
                git branch: 'master', url: 'https://github.com/hamzaiteam/angular_app.git' ,credentialsId: 'git-credentials'
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

        stage('Test') {
            steps {
                sh 'npm test'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('My SonarQube') {
                    // Run SonarQube analysis using the scanner; update parameters as needed
                    sh """
                       npx sonar-scanner \
                       -Dsonar.projectKey=angular_app \
                       -Dsonar.sources=./src \
                       -Dsonar.host.url=\$SONARQUBE_URL \
                       -Dsonar.login=\$SONARQUBE_AUTH_TOKEN
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Tag the Docker image with the Jenkins BUILD_NUMBER for versioning
                    sh """
                        docker build -t \${DOCKERHUB_CREDENTIALS_USR}/angular_app:\${BUILD_NUMBER} .
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Login to Docker Hub using the credentials from Jenkins
                    sh "docker login -u \${DOCKERHUB_CREDENTIALS_USR} -p \${DOCKERHUB_CREDENTIALS_PSW}"
                    sh "docker push \${DOCKERHUB_CREDENTIALS_USR}/angular_app:\${BUILD_NUMBER}"
                }
            }
        }
    }
}
