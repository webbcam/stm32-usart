#!/usr/bin/env groovy

pipeline {
    agent {
        docker {
            image 'webbcam/arm-none-eabi-gcc'
            args '-u root'
        }
    }

    stages {
        stage('Build') {
            steps {
                echo 'Building...'
                sh 'mkdir build'
                dir("build") {
                    sh 'pwd'
                    sh 'cmake .. -DCMAKE_BUILD_TYPE=RELEASE'
                    sh 'make'
                }
            }
            post {
                success {
                    archiveArtifacts artifacts: 'build/*.elf'
                }
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
                sh 'ls'
            }
        }
    }
}
