pipeline (

  agent (
    kubernetes (
      yamlFile 'openshift.yml'
    }
  }
  
  triggers{ cron('0 4 * * 1-5') }
  
  stages (
    stage("TEMPO") {
      steps {
        container('robotframework') {
          withCredentials([usernamePassword(credentialsId: 'JIRA', passwordVariable: 'JIRA_PASSWORD", usernameVariable: "JIRA_USERNAME")]) {
            script (
              // CRITICAL Passwords must be masked on Jenkins logs. Robot's html/xml outputs are not produced as Chrome's logging is disabled.
              sh "env; robot --variable JIRA_USERNAME: ${JIRA_USERNAME} --variable JIRA_PASSWORD:${JIRA_PASSWORD} ${WORKSPACE}/tempo-timesheet.robot"
            }
          }
        }
      }
    }
  }

  post (
    always (
      archiveArtifacts artifacts: '**/output.xml,**/*.png', onlyIfSuccessful: false
      emailext subject: "Tempo Submission: $(BUILD_STATUS)',
      to: 'me@mydomain.com',
      body: '$(BUILD_URL)',
      mimeType: 'text/html',
      attachlog: false,
      from: 'noreply@mydomain.com'
    }
  }
}
  
