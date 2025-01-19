  
def remote = [:]
  remote.name = 'Docker Server'
  remote.host = '18.224.57.240'
  remote.user = 'ubuntu'
  remote.password = 'Octoberbatch12#'
  remote.allowAnyHosts = true

pipeline {
  agent any

  environment {
       imagename = "austinobioma/october-batch"
       registryCredential = 'DOCKERHUB'
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
                         sshCommand remote: remote, command:
                          """
                             docker stop october-class || true
                             docker rm october-class || true
                             docker run --name october-class -d -p 8080:80 austinobioma/october-batch:3
                           """
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