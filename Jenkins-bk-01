pipeline {
    agent any

    environment {
        GIT_REPO = "https://github.com/DITISS-AUG24-PROJECT/A2.git" // Update with your repo
        BRANCH = "final-build"
        APP_DIR = "app"
        TARGET_URL = "http://192.168.80.171:9080" // Update if needed
        EMAIL_RECIPIENT = "samrajya2002@gmail.com"
        SONAR_HOME = tool "Sonar" // Define SonarQube scanner tool
    }

    stages {
        stage("Clone Repository from GitHub") {
            steps {
                git url: "${GIT_REPO}", branch: "${BRANCH}"
            }
            post {
                success {
                    emailext subject: "✅ Build Success: ${env.JOB_NAME} - Clone Stage",
                             body: "GitHub clone completed successfully.",
                             to: "${EMAIL_RECIPIENT}"
                }
                failure {
                    emailext subject: "❌ Build Failed: ${env.JOB_NAME} - Clone Stage",
                             body: "GitHub clone failed. Check logs.",
                             to: "${EMAIL_RECIPIENT}"
                }
            }
        }

        stage("Deploy with Docker Compose") {
            steps {
                sh 'docker rm -f vulnerable-app || true'
                sh 'docker compose down --remove-orphans'
                sh 'docker compose up -d --build'
            }
            post {
                success {
                    emailext subject: "✅ Build Success: ${env.JOB_NAME} - Deployment Stage",
                             body: "Application deployed successfully using Docker Compose.",
                             to: "${EMAIL_RECIPIENT}"
                }
                failure {
                    emailext subject: "❌ Build Failed: ${env.JOB_NAME} - Deployment Stage",
                             body: "Docker Compose deployment failed. Check logs.",
                             to: "${EMAIL_RECIPIENT}"
                }
            }
        }

        stage("SonarQube Quality Analysis") {
            steps {
                withSonarQubeEnv("Sonar") {
                    sh '''
                    ${SONAR_HOME}/bin/sonar-scanner \
                    -Dsonar.projectName=Final-build \
                    -Dsonar.projectKey=Final-build
                    '''
                }
            }
            post {
                success {
                    emailext subject: "✅ Build Success: ${env.JOB_NAME} - SonarQube Analysis",
                             body: "SonarQube analysis completed successfully.",
                             to: "${EMAIL_RECIPIENT}"
                }
                failure {
                    emailext subject: "❌ Build Failed: ${env.JOB_NAME} - SonarQube Analysis",
                             body: "SonarQube analysis failed. Check logs.",
                             to: "${EMAIL_RECIPIENT}"
                }
            }
        }

        stage("Sonar Quality Gate Scan") {
            steps {
                timeout(time: 5, unit: "MINUTES") {
                    waitForQualityGate abortPipeline: false
                }
            }
            post {
                success {
                    emailext subject: "✅ Build Success: ${env.JOB_NAME} - Sonar Quality Gate",
                             body: "Sonar Quality Gate passed successfully.",
                             to: "${EMAIL_RECIPIENT}"
                }
                failure {
                    emailext subject: "❌ Build Failed: ${env.JOB_NAME} - Sonar Quality Gate",
                             body: "Sonar Quality Gate failed. Check logs.",
                             to: "${EMAIL_RECIPIENT}"
                }
            }
        }

        stage("Trivy File System Scan") {
            steps {
                sh "trivy fs --format table -o trivy-fs-report.html ."
            }
            post {
                success {
                    emailext subject: "✅ Build Success: ${env.JOB_NAME} - Trivy Scan",
                             body: "Trivy file system scan completed successfully.",
                             to: "${EMAIL_RECIPIENT}"
                }
                failure {
                    emailext subject: "❌ Build Failed: ${env.JOB_NAME} - Trivy Scan",
                             body: "Trivy file system scan failed. Check logs.",
                             to: "${EMAIL_RECIPIENT}"
                }
            }
        }

        stage("Run ZAP Baseline Scan") {
            steps {
                sh '''
                docker run --rm zaproxy/zap-stable zap-baseline.py -t ${TARGET_URL}
                '''
            }
            post {
                success {
                    emailext subject: "✅ Build Success: ${env.JOB_NAME} - Baseline Scan",
                             body: "ZAP Baseline Scan completed successfully.",
                             to: "${EMAIL_RECIPIENT}"
                }
                failure {
                    emailext subject: "❌ Build Failed: ${env.JOB_NAME} - Baseline Scan",
                             body: "ZAP Baseline Scan failed. Check logs.",
                             to: "${EMAIL_RECIPIENT}"
                }
            }
        }

        stage("Run ZAP Full Scan") {
            steps {
                sh '''
                docker run --rm zaproxy/zap-stable zap-full-scan.py -t ${TARGET_URL}
                '''
            }
            post {
                success {
                    emailext subject: "✅ Build Success: ${env.JOB_NAME} - Full Scan",
                             body: "ZAP Full Scan completed successfully.",
                             to: "${EMAIL_RECIPIENT}"
                }
                failure {
                    emailext subject: "❌ Build Failed: ${env.JOB_NAME} - Full Scan",
                             body: "ZAP Full Scan failed. Check logs.",
                             to: "${EMAIL_RECIPIENT}"
                }
            }
        }

        stage("Cleanup") {
            steps {
                sh 'docker-compose down'
            }
            post {
                success {
                    emailext subject: "✅ Build Success: ${env.JOB_NAME} - Cleanup Stage",
                             body: "Docker Compose services cleaned up successfully.",
                             to: "${EMAIL_RECIPIENT}"
                }
                failure {
                    emailext subject: "❌ Build Failed: ${env.JOB_NAME} - Cleanup Stage",
                             body: "Cleanup process failed. Check logs.",
                             to: "${EMAIL_RECIPIENT}"
                }
            }
        }
    }

    post {
        always {
            emailext (
                subject: "🔔 Pipeline Status: ${BUILD_NUMBER}",
                body: '''<html>
                            <body> 
                                <p>Build Status: ${BUILD_STATUS}</p>
                                <p>Build Number: ${BUILD_NUMBER}</p>
                                <p>Check the <a href="${BUILD_URL}">console output</a>.</p>
                            </body>
                         </html>''',
                to: "${EMAIL_RECIPIENT}",
                from: "jenkins@example.com",
                replyTo: "jenkins@example.com",
                mimeType: "text/html"
            )
        }
    }
}

