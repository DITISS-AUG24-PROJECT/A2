pipeline{
    agent any
    environment{
        SONAR_HOME=tool "Sonar"
    } 
        stage("Test"){
            steps{
                echo "this is a test"
            }
        }
        stage("OWASP Dependency Check"){
            steps{
                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'OWASP-DC'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        stage("Test 2"){
            steps{
                echo "this is a test 2"
            }
        }
}

