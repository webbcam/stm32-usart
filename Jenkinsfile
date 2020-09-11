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
                sh 'mkdir build && cd build'
                sh 'cmake .. -DCMAKE_BUILD_TYPE=RELEASE'
                sh 'make'
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
