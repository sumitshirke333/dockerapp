pipeline {
    agent any
    environment {
    //SONAR_HOST = 'http://localhost:9000'
    //SONAR_TOKEN = credentials('sonarqubetoken')
    REGISTRY_URL = 'localhost:5000'  // or your actual Docker registry URL
  }

    stages {


    
    stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
    
    stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/deopura/dockerapp.git'
          }
        }

   /* stage('SonarQube Analysis') {
            steps {
            withSonarQubeEnv('SonarQube') {
                script {
                def scannerHome = tool name: 'SonarScanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=sonartest -Dsonar.sources=."
                    // sh "${scannerHome}/bin/sonar-scanner"
                }
                }
            }
            }  */    

    stage('Build') {
            steps {
                echo 'Building..'
                // Check the docker-compose version
                sh 'docker compose version'
                // build the image
                //sh 'docker compose build'
                sh 'docker build -t $REGISTRY_URL/myapp:latest .'
                //sh 'docker compose up -d'               // Ensure the services are running
            }
        }

    stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexusdocker', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login $REGISTRY_URL -u "$DOCKER_USER" --password-stdin
                    """
                }
            }
        }

    stage('Push') {
                steps {
                    //sh 'docker build -t $REGISTRY_URL/myrepo/myapp:latest .'
                    sh 'docker compose push'
                }
            }
    
        stage('Deploy') {
            steps {
                echo 'Deploying....'
                sh 'docker compose up -d'
                sh 'docker compose ps'
                sh 'docker logout $REGISTRY_URL'
            }
        }
    }
}   