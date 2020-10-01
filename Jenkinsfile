pipeline {
    agent any

    environment {
        WORKSPACE_PATH = "/data/backups/jenkins/${WORKSPACE.substring(18)}"
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    stages {
        stage('Build') {
            steps {
                sh 'DOCKER_BUILDKIT=1 docker build -t byrdal/nagios:latest .'
            }
        }

        stage('Tag') {
            when {
                buildingTag()
            }
            steps {
                script {
                    docker.withRegistry('', 'dockerhub') {
                        sh 'docker tag byrdal/nagios:latest byrdal/nagios:${BRANCH_NAME}'
                        sh 'docker push byrdal/nagios:${BRANCH_NAME}'
                        sh 'docker push byrdal/nagios:latest'
                    }
                }
            }
        }
    }

    post {
        changed {
            script {
                // See https://stackoverflow.com/a/45990856 for example
                emailext subject: '$DEFAULT_SUBJECT',
                    body: '$DEFAULT_CONTENT',
                    recipientProviders: [
                        [$class: 'CulpritsRecipientProvider'],
                        [$class: 'DevelopersRecipientProvider'],
                        [$class: 'RequesterRecipientProvider']
                    ],
                    replyTo: '$DEFAULT_REPLYTO',
                    to: '$DEFAULT_RECIPIENTS'
            }
        }
    }
}
