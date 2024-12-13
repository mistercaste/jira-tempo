# Jira/Tempo Automation
Automates the compilation of TEMPO time-sheets.
How? Specify some ticket numbers in `tickets.txt` and it will randomly pick them to populate the requested time interval in Jira TEMPO.
Pick the ticket numbers from your _Time Tracking_ project (e.g. BLAH-xxx). See below a sample Jira query to retrieve them:
```
project = "Time Tracking" AND issuetype = Epic AND description ~ TribeName
```

## Usage
The tool can be executed in either mode:

#### CloudBees / OpenShift
* Logout Jira's SSO and login over HTTPs with (`username/password`). Answer potential CAPTCHAs
* Provide your _CloudBees CI_ folder with your JIRA credentials (type _username/password_) and name the ID `JIRA`
* Setup a _Cloudbees CI_ pipeline to point to this project's Jenkinsfile
* _Optional_ - Setup a nightly run of your pipeline

#### CLI
* Execute `run.sh <YOUR_JIRA_USERNAME> <YOUR_JIRA_PASSWORD>` (must be root and have Docker installed)
* Run the command below:
```
sudo docker run --rm \
     --user root \
     -v $(pwd):/opt/robotframework/tests:Z \
     -v $(pwd)/reports:/opt/robotframework/reports:Z \
     -w /opt/robotframework/tests \
     christophettat/devops_coe_robot /bin/sh -c 'env ; robot --variable JIRA_USERNAME:<YOUR_JIRA_USERNAME> --variable JIRA_PASSWORD <YOUR_JIRA_PASSWORD> --variable RANGE_START:2025-1-1 /opt/robotframework/tests/tempo-timesheet.robot'
```

#### CODE CONFIGURATIONS
You'll need to hard-code some parameters (sorry, didn't find the time to parameterized them for general purpose usage)

resources.robot
* JIRA_URL
* Potentially the script, depending on your IT dept. configuration

run.sh
* TIMEZONE : must match your _CloudBees CI_
* CONTAINER_IMAGE : set to your registry hub

openshift.yml
* spec/imagePullSecrets
* containers/image (both _robotframework_ and _jnlp_ containers)

#### CLOUDBEES CI - EMAIL NOTIFICATIONS
In order to enable the email notifications, please add into `Jenkins -> Configure System -> Extended Email Notifications` the values below:
```
SMTP server : smtp.acme.com
SMTP port : 25
```

#### TROUBLESHOOTING
In case of issues try the following:
* Logout Jira's SSO and login over HTTPs with (`username/password`). Answer potential CAPTCHAs
* Set your Jira timezone to GMT (rationale: Docker containers are often executed by default in UTC time)
* Click your build number in `CloudBees CI --> Pipeline Steps --> Node (the first occurrence) --> Workspace --> selenium-screenshot-1.png` (you'll need to be VERY quick when refreshing CTRL+F5)
