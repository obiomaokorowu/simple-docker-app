pipeline {
    agent any

    environment {
        imagename = "austinobioma/august-class"
        registryCredential = 'DOCKERHUB-CRED'
        dockerImage = ''
        imagetag = "${env.BUILD_ID}"
    }

    stages {
        stage('Building Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${imagename}:${imagetag}")
                }
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                script {
                    docker.withRegistry('', registryCredential) {
                        dockerImage.push("${imagetag}")
                    }
                }
            }
        }

        stage('Deploy to Docker Server Using SSH') {
            steps {
                script {
                    def remote = [
                        name: 'Docker Server',
                        host: '13.135.214.214',
                        user: 'ubuntu',
                        allowAnyHosts: true
                    ]

                    withCredentials([sshUserPrivateKey(credentialsId: 'SSH-KEY', keyFileVariable: 'identity', passphraseVariable: '', usernameVariable: 'userName')]) {
                        remote.user = userName
                        remote.identityFile = identity

                        sshCommand remote: remote, command: """
                            docker stop august-class || true
                            docker rm august-class || true
                            docker pull ${imagename}:${imagetag}
                            docker run --name august-class -d -p 8080:80 ${imagename}:${imagetag}
                        """
                    }
                }
            }
        }

        stage('Remove Unused Docker Images') {
            steps {
                sh "docker system prune -f"
            }
        }
    }
}
