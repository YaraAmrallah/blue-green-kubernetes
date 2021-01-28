pipeline {
    environment{
        registryCredential = 'dockerhub' 
        greenDockerImage = '' 
        blueDockerImage = ''
    }
    agent any 
    stages {
        stage('Install Requirements'){
            steps{
                sh "pip3 install -r requirements.txt"
            }
        }

        stage('Lint Code'){
            steps {
                sh "bash ./run_pylint.sh"
            }
        }

        stage('Set K8S Context'){
            steps {
                withAWS(credentials:'aws-static'){
                    sh "kubectl config set-context arn:aws:eks:us-east-2:430448871340:cluster/EKS-Cluster"
                }
            }
        }

        stage('Build Green Docker Image') {
            steps {
                script{
                    greenDockerImage = docker.build "yaraamrallah/pre-production-flask-app"
                }
            }
        }

        stage('Upload Green Image to Docker-Hub'){
            steps{
                script{
                    docker.withRegistry('', registryCredential){
                        greenDockerImage.push()
                    }
                }
            }
        }

        stage('Clean Up Green Image'){
            steps { 
                sh "docker rmi yaraamrallah/pre-production-flask-app:latest" 
            }
        }

        stage('Green Deployment'){
            steps {
                withAWS(credentials:'aws-static'){
                    sh "kubectl apply -f k8s/Green/green-deployment.yaml && kubectl apply -f k8s/Green/test-service.yaml"
                }
            }
        }

        stage('Test Green Deployment'){
            steps{
                input "Deploy to production?"
            }
        }

        stage('Switch Traffic To Green Deployment'){
            steps{
                withAWS(credentials:'aws-static'){
                    sh "kubectl apply -f k8s/Green/green-service.yaml"
                }
            }
        }

        stage('Build Blue Docker Image') {
            steps {
                script{
                    blueDockerImage = docker.build "yaraamrallah/flask-app"
                }
            }
        }

        stage('Upload Blue Image to Docker-Hub'){
            steps{
                script{
                    docker.withRegistry('', registryCredential){
                        blueDockerImage.push()
                    }
                }
            }
        }

        stage('Clean Up Blue Image'){
            steps { 
                sh "docker rmi yaraamrallah/flask-app:latest" 
            }
        }

        stage('Blue Deployment'){
            steps {
                withAWS(credentials:'aws-static'){
                    sh "kubectl apply -f k8s/Blue"
                }
            }
        }
    }
}
