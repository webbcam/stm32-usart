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
                sh 'ls'
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
