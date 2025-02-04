pipeline {
    agent any
    environment {
       SONAR_HOME = tool "Sonar" 
    }
    stages{
        stage("Clone Code from GitHub"){
            steps{
                git branch: "auto-build", url: "https://github.com/DITISS-AUG24-PROJECT/A2.git"
            }
        }
        stage("SonarQube Quality Analysis") {
            steps{
                withSonarQubeEnv("Sonar"){
                    sh "$SONAR_HOME/bin/sonar-scanner -Dsonar.projectName=DeliDrop -Dsonar.projectKey=DeliDrop"
                }
            }
        }
        stage("OWASP Dependency Check"){
            steps{
                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'OWASP-DC'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage("Sonar Quality Gate scan"){
            steps{
                timeout(time: 2, unit: "MINUTES"){
                    waitForQualityGate abortPipeline: false
                }
            }
        }
        stage("Trivy File System Scan") {
            steps{
                sh "trivy  fs --format table -o trivy-fs-report.html ."
            }
        }
        stage("Deploy"){
            steps{
                echo "Deploying to production"
            }
        }
    }
}
