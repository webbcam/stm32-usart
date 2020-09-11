#!/usr/bin/env groovy

pipeline {
    agent {
        docker {
            image 'webbcam/arm-none-eabi-gcc'
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
                    zip archive: true, dir: 'build', glob: '*.map, *.elf, *.bin', zipFile: "${env.JOB_NAME}-${env.BUILD_NUMBER}.zip"
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
