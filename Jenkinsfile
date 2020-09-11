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
                dir("build") {
                    sh 'cmake .. -DCMAKE_BUILD_TYPE=DEVELOP'
                    sh 'make'
                }
            }
            post {
                success {
                    zip archive: true, dir: 'build', glob: '*.map, *.elf, *.bin, *.hex', zipFile: "stm32f1-blink-${env.BRANCH_NAME}-B${env.BUILD_NUMBER}.zip"
                }
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
            }
        }
    }
}
