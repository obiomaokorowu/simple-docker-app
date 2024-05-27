  
def remote = [:]
  remote.name = 'Docker Server'
  remote.host = '18.191.122.7'
  remote.user = 'ubuntu'
  remote.password = 'ubuntu'
  remote.allowAnyHosts = true

pipeline {
  agent any

  environment {
       imagename = "mayorpasca32/my1dokarepo"
       registryCredential = 'DOCKERLOGIN'
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
                         sshCommand remote: remote, command: "docker run --name may-docker-class -d -p 9090:80 mayorpasca32/my1dokarepo:9"
                    }
               }
          }

          stage('Remove Unused docker image') {
               steps{
                    //sh "docker rmi $imagename:$BUILD_NUMBER"
                    //sh "docker rmi $imagename:$imagetag"
                    sh "docker system prune -f"
                    }
          }
    
     }
}
