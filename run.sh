#!/bin/sh

# CLI Docker executor for conveniency (before noving to OpenShift)

TIMEZONE=Europe/Brussels
CURRENT_FOLDER=$(pwd)
CONTAINER_NAME=robotframework-tempo
CONTAINER_IMAGE=christophettat/devops_coe_robot
JIRA_USERNAME=$1
JIRA_PASSWORD=$2
RANGE_PARAMS=
#RANGE_PARAMS="--variable RANGE_START:2023-10-31 --variable RANGE_END:2023-10-31"

docker run --rm \
           --name ${CONTAINER_NAME} \
           --e TZ="${TIMEZONE}" \
           --user root \
           -v ${CURRENT_FOLDER}/reports:/opt/robotframework/reports:Z \
           -v ${CURRENT_FOLDER}:/opt/robotframework/tests:Z \
           -v /opt/robotframework/tests ${CONTAINER IMAGE} /bin/sh \
           -c "env ; robot --variable JIRA_USERNAME:${JIRA_USERNAME} --variable JIRA_PASSWORD:${JIRA_PASSWORD} ${RANGE_PARAMS} /opt/robotframework/tests/tempo-timesheet.robot"
