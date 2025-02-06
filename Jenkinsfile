pipeline {
    agent any

    environment {
        REPORT_DIR = "dependency-check-reports"  // Directory to store reports
    }

    stages {
        stage("Run OWASP Dependency Check") {
            steps {
                script {
                    sh "mkdir -p ${REPORT_DIR}"
                    sh """
                    docker run --rm -v \$(pwd):/src -v \$(pwd)/${REPORT_DIR}:/report owasp/dependency-check \
                    --scan /src --format HTML --out /report/dependency-check-report.html
                    """
                }
            }
        }

        stage("Archive Reports") {
            steps {
                archiveArtifacts artifacts: "${REPORT_DIR}/dependency-check-report.html", fingerprint: true
            }
        }
    }
}

