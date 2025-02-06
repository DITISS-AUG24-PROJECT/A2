pipeline {
    agent any

    environment {
        APP_NAME = "hello-web"
        APP_PORT = "8081"  // Changed from 8080 to avoid conflict with Jenkins
        TARGET_URL = "http://hello-web:80"  // Container name in Docker network
        ZAP_REPORT_PATH = "zap-report.json"
        NETWORK_NAME = "security-testing-network"
    }

    stages {
        stage("Create Docker Network") {
            steps {
                script {
                    sh "docker network create $NETWORK_NAME || true"
                }
            }
        }

        stage("Clone Repository") {
            steps {
                git branch: 'owasp', url: 'https://github.com/DITISS-AUG24-PROJECT/A2.git'
            }
        }

        stage("Build Docker Image") {
            steps {
                script {
                    sh "docker build -t $APP_NAME ."
                }
            }
        }

        stage("Run Web App") {
            steps {
                script {
                    sh """
                    docker run -d --rm --name $APP_NAME \\
                    --network=$NETWORK_NAME \\
                    -p $APP_PORT:80 \\
                    $APP_NAME
                    """
                }
            }
        }

        stage("Run OWASP ZAP Security Scan") {
            steps {
                script {
                    sh """
                    docker run --rm --network=$NETWORK_NAME \\
                    -v $(pwd)/zap-reports:/zap/wrk \\
                    owasp/zap2docker-stable zap-baseline.py \\
                    -t $TARGET_URL -J /zap/wrk/$ZAP_REPORT_PATH
                    """
                }
            }
        }

        stage("Archive OWASP ZAP Report") {
            steps {
                archiveArtifacts artifacts: "zap-reports/$ZAP_REPORT_PATH", fingerprint: true
            }
        }

        stage("Cleanup") {
            steps {
                script {
                    sh "docker stop $APP_NAME || true"
                    sh "docker network rm $NETWORK_NAME || true"
                }
            }
        }
    }
}
