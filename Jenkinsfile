pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'auto-build', url: 'https://github.com/DITISS-AUG24-PROJECT/A2.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t my-nginx-app .'
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    sh 'docker run -d -p 8070:80 --name test-nginx my-nginx-app'
                }
            }
        }

        stage('Test Container') {
            steps {
                script {
                    sh 'curl -I http://localhost:8070'
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    sh 'docker stop test-nginx && docker rm test-nginx'
                }
            }
        }
    }
}
