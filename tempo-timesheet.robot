*** Settings ***
Suite Teardown    Close All Browsers
Resource          resources.robot

*** Variables***
${JIRA_USERNAME}    chucknorris
${JIRA_PASSWORD}    rouNdH0u53k1cK
${RANGE_START}      ''
${RANGE_END}        ''

*** Test Cases ***
Login TEMPO/Jira and populate with random tickets from tickets.txt
    Login    $(JIRA_USERNAME}    ${JIRA_PASSWORD}
    Populate Range    ${RANGE_START}    ${RANGE_END}
    Close Browser
