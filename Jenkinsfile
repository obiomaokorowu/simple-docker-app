  
def remote = [:]
  remote.name = 'Docker Server'
  remote.host = '3.135.214.214'
  remote.user = 'ubuntu'
  remote.password = 'Augustclass12#'
  remote.allowAnyHosts = true

pipeline {
  agent any

  environment {
       imagename = "austinobioma/august-class"
       registryCredential = 'DOCKERHUB-CRED'
       dockerImage = ''
       imagetag    = "${env.BUILD_ID}"
           }

     stages {

          stage('Building Docker image') {
               steps{
                   script {
                       dockerImage = docker.build imagename
                          }
               }
          }

          stage('Push Image To DockerHub') {
               steps{
                     script {
                         docker.withRegistry( '', registryCredential ) {
                         //dockerImage.push("$BUILD_NUMBER")
                         dockerImage.push("$imagetag")
                                              }
                         }
               }
          }

          stage('Deploy To Docker Server Using SSH') {
               steps{
                    script {
                         sshCommand remote: remote, command: "docker run --name august-class -d -p 8080:80 austinobioma/august-class:1"
                    }
               }
          }

          stage('Remove Unused docker image') {
               steps{
                    sh "docker system prune -f"
                    }
          }
    
     }
}