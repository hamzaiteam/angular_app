pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials') 
        // Jenkins credential ID with username/password for Docker Hub
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/your-username/angular-cicd-demo.git'
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
                    // Use SonarQube Scanner
                    sh """
                       npx sonar-scanner \
                       -Dsonar.projectKey=angular-cicd-demo \
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
                    // We'll tag the image with the Jenkins BUILD_NUMBER for versioning
                    sh """
                        docker build -t \${DOCKERHUB_CREDENTIALS_USR}/angular-cicd-demo:\${BUILD_NUMBER} .
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh "docker login -u \${DOCKERHUB_CREDENTIALS_USR} -p \${DOCKERHUB_CREDENTIALS_PSW}"
                    sh "docker push \${DOCKERHUB_CREDENTIALS_USR}/angular-cicd-demo:\${BUILD_NUMBER}"
                }
            }
        }
    }
}
