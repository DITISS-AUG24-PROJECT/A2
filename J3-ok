pipeline {
    agent any

    environment {
        SONAR_HOME = tool "Sonar"
    }

    stages {
        stage("Clone Repository") {
            steps {
                git branch: 'auto-build', url: 'https://github.com/DITISS-AUG24-PROJECT/A2.git'
            }
        }

        stage("SonarQube Quality Analysis (SAST)") {
            steps {
                withSonarQubeEnv("Sonar") {
                    sh "$SONAR_HOME/bin/sonar-scanner -Dsonar.projectName=OneGo -Dsonar.projectKey=OneGo"
                }
            }
        }

        stage("Sonar Quality Gate Check") {
            steps {
                timeout(time: 5, unit: "MINUTES") { // Increased timeout
                    waitForQualityGate abortPipeline: true // Abort if quality gate fails
                }
            }
        }

        stage("OWASP Dependency Check") {
            steps {
                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'OWASP-DC'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        stage("Trivy File System Scan") {
            steps {
                sh "trivy fs --format table -o trivy-fs-report.html ."
            }
        }

        stage("Build Docker Image") {
            steps {
                script {
                    // Ensure Docker is available and permissions are set
                    sh 'docker version'
                    sh 'docker build -t my-nginx-app .'
                }
            }
        }

        stage("Run & Test Container") {
            steps {
                script {
                    // Ensure that Docker is up and running
                    sh 'docker ps'
                    
                    // Run container and wait for it to be ready
                    sh 'docker run -d -p 8070:80 --name test-nginx my-nginx-app'
                    sleep(10) // Increase sleep time to ensure the container starts properly
                    
                    // Test if the container is responding
                    sh 'curl -I http://localhost:8070'
                }
            }
        }

        stage("OWASP ZAP DAST Scan") {
            steps {
                script {
                    // Assuming OWASP ZAP is already set up as a tool in Jenkins
                    sh "zap-baseline.py -t http://localhost:8070 -g gen.conf -r zap_report.html"
                }
            }
        }

        stage("Cleanup") {
            steps {
                script {
                    // Proper cleanup with condition to check if container is running
                    sh '''
                    if [ $(docker ps -q -f name=test-nginx) ]; then
                        docker stop test-nginx && docker rm test-nginx
                    fi
                    '''
                }
            }
        }

        stage("Deploy") {
            steps {
                echo "Deploying to production"
            }
        }
    }
}
